import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_mapa_widget.dart' show HomeMapaWidget;
import 'package:flutter/material.dart';
import 'dart:async';

class HomeMapaModel extends FlutterFlowModel<HomeMapaWidget> {
  // Map control variables
  double zoomLevel = 1.0;
  double minZoom = 0.5;
  double maxZoom = 3.0;
  Offset mapOffset = Offset.zero;
  
  // Map image dimensions (to be used as reference for coordinate system)
  double mapWidth = 1200.0;
  double mapHeight = 600.0;
  
  // Base pan limits (will be scaled by zoom level)
  double maxPanLeft = 600.0;
  double maxPanRight = 600.0;
  double maxPanUp = 450.0;
  double maxPanDown = 450.0;
  
  // Track if we're at pan limits (for visual feedback)
  bool isAtLeftLimit = false;
  bool isAtRightLimit = false;
  bool isAtTopLimit = false;
  bool isAtBottomLimit = false;
  
  // API request completer for beacons
  Completer<ApiCallResponse>? apiRequestCompleter;
  
  // Auto-refresh timer para atualizar posições a cada 5 segundos
  Timer? _autoRefreshTimer;
  
  // Cache variables para reduzir requisições
  List<MapItem>? _cachedMapItems;
  DateTime? _lastFetchTime;
  static const Duration _cacheTimeout = Duration(seconds: 5);
  bool _isLoading = false;
  
  // Filter variables
  bool showFilterMenu = false;
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  
  // Machine filters
  bool filterEstacaoCarga = false;
  bool filterImpressora3d = false;
  bool filterImpressora = false;
  bool filterMaquinaCorrosao = false;
  bool filterEstacaoSolda = false;
  bool filterCNC = false;
  bool filterMaquinaCorte = false;
  bool filterBancadaReparos = false;
  
  // Beacon filters
  bool filterMultimetro = false;
  bool filterKitReparos = false;
  bool filterChapaMaterial = false;
  bool filterEstanho = false;
  bool filterComponentes = false;
  bool filterFilamento = false;
  
  // Type filters
  bool filterMaterial = false;
  bool filterFerramenta = false;
  bool filterMaquina = false;
  bool filterFuncionario = false;

  // Status filters
  bool filterEmUso = false;
  bool filterDisponivel = false;
  bool filterDescarregado = false;
  bool filterProcessado = false;
  bool filterIndisponivel = false;
  bool filterCarregando = false;
  bool filterCarregado = false;
  
  Future<List<MapItem>> getAllMapItems({bool forceRefresh = false}) async {
    // Se forçar refresh ou não tem cache válido
    if (forceRefresh || 
        _cachedMapItems == null || 
        _lastFetchTime == null || 
        DateTime.now().difference(_lastFetchTime!) > _cacheTimeout) {
      
      // Evita múltiplas chamadas simultâneas
      if (_isLoading) {
        while (_isLoading) {
          await Future.delayed(Duration(milliseconds: 100));
        }
        if (_cachedMapItems != null) {
          return getFilteredMapItems(_cachedMapItems!);
        }
      }
      
      _isLoading = true;
      
      try {
        List<MapItem> allItems = [];
        
        final apiResponse = await BeaconsGetAllCall.call();
        if (apiResponse.statusCode == 200) {
          final beaconsMap = getJsonField(apiResponse.jsonBody, r'''$.Beacons''') as Map<String, dynamic>? ?? {};
          
          // Agrupa beacons por ID e pega apenas a última ocorrência (UTC mais recente)
          Map<String, dynamic> latestBeacons = {};
          
          for (var beaconData in beaconsMap.values) {
            String beaconId = beaconData['beacon'] ?? '';
            int utc = beaconData['utc'] ?? 0;
            
            if (beaconId.isNotEmpty) {
              if (!latestBeacons.containsKey(beaconId) || 
                  (latestBeacons[beaconId]['utc'] ?? 0) < utc) {
                latestBeacons[beaconId] = beaconData;
              }
            }
          }
          
          // Converte as últimas ocorrências em MapItems
          for (var beaconData in latestBeacons.values) {
            // Determine category based on beacon type
            String category = _getCategoryFromBeaconType(beaconData['tipo'] ?? '');
            
            allItems.add(MapItem(
              id: beaconData['id']?.toString() ?? '',
              name: beaconData['beacon'] ?? '',
              type: category,
              category: category,
              x: (beaconData['x']?.toDouble() ?? 0.0) * 100.0, // Scale coordinates
              y: (beaconData['y']?.toDouble() ?? 0.0) * 100.0, // Scale coordinates
              status: beaconData['status'] ?? 'disponivel',
              utc: beaconData['utc'] ?? 0,
            ));
          }
        }
        
        // Salva no cache
        _cachedMapItems = allItems;
        _lastFetchTime = DateTime.now();
        
        return getFilteredMapItems(allItems);
      } catch (e) {
        print('Error loading beacons: $e');
        // Se tem cache, usa ele mesmo expirado
        if (_cachedMapItems != null) {
          return getFilteredMapItems(_cachedMapItems!);
        }
        return getFilteredMapItems([]);
      } finally {
        _isLoading = false;
      }
    }
    
    // Retorna cache válido
    return getFilteredMapItems(_cachedMapItems!);
  }
  
  // Determine category from beacon type
  String _getCategoryFromBeaconType(String tipo) {
    tipo = tipo.toLowerCase();
    if (tipo.contains('maquina') || tipo == 'maquina') {
      return 'maquina';
    } else if (tipo.contains('ferramenta') || tipo.contains('multimetro') || tipo.contains('kit')) {
      return 'ferramenta';
    } else if (tipo.contains('material') || tipo.contains('chapa') || tipo.contains('estanho') || 
               tipo.contains('filamento') || tipo.contains('componentes')) {
      return 'material';
    } else if (tipo.contains('pessoa') || tipo.contains('operador')) {
      return 'pessoa';
    } else {
      return 'material'; // Default
    }
  }

  @override
  void initState(BuildContext context) {
    textController ??= TextEditingController();
    textFieldFocusNode ??= FocusNode();
    startAutoRefresh(); // Inicia o refresh automático
  }

  @override
  void dispose() {
    textController?.dispose();
    textFieldFocusNode?.dispose();
    stopAutoRefresh(); // Para o refresh automático
  }
  
  // Função para iniciar o refresh automático a cada 5 segundos
  void startAutoRefresh() {
    stopAutoRefresh(); // Para qualquer timer existente
    _autoRefreshTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      // Força uma atualização pegando sempre os dados mais recentes
      // Não precisa notificar o widget aqui, o widget tem seu próprio timer
      clearCache(); // Limpa cache para forçar nova busca
    });
  }
  
  // Função para parar o refresh automático
  void stopAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }
  
  // Get scaled coordinates based on zoom and offset
  Offset getScaledPosition(double x, double y, Size containerSize) {
    double scaledX = (x * zoomLevel) + mapOffset.dx + (containerSize.width / 2) - (mapWidth * zoomLevel / 2);
    double scaledY = (y * zoomLevel) + mapOffset.dy + (containerSize.height / 2) - (mapHeight * zoomLevel / 2);
    return Offset(scaledX, scaledY);
  }
  
  // Get color based on category and status
  Color getItemColor(String category, String status) {
    switch (status.toLowerCase()) {
      case 'ativo':
      case 'disponivel':
        return Color(0xFF4CAF50); // Green
      case 'inativo':
      case 'indisponivel':
        return Color(0xFF757575); // Grey
      case 'manutencao':
        return Color(0xFFF44336); // Red
      case 'em_uso':
      case 'em uso':
        return Color(0xFFFF9800); // Orange
      case 'baixo_estoque':
      case 'descarregado':
        return Color(0xFFE91E63); // Pink
      case 'carregando':
        return Color(0xFF2196F3); // Blue
      case 'carregado':
        return Color(0xFF00BCD4); // Cyan
      case 'processado':
        return Color(0xFF9C27B0); // Purple
      default:
        return Color(0xFF607D8B); // Blue Grey
    }
  }

  // Get icon for different item categories (only 4 types)
  IconData getItemIcon(String category) {
    switch (category.toLowerCase()) {
      case 'maquina':
        return Icons.precision_manufacturing;
      case 'ferramenta':
        return Icons.build;
      case 'pessoa':
        return Icons.person;
      case 'material':
        return Icons.inventory_2;
      default:
        return Icons.radio_button_checked; // Fallback
    }
  }
  
  // Update zoom level
  void updateZoom(double newZoom) {
    zoomLevel = newZoom.clamp(minZoom, maxZoom);
  }
  
  // Update map offset for panning (constrained to predefined limits)
  void updateOffset(Offset delta) {
    // Calculate new offset
    final newOffset = mapOffset + delta;
    
    // Apply zoom-based scaling to pan limits (more zoom = more pan allowed)
    // When zoomed in, we see less of the map, so we need more pan distance
    // When zoomed out, we see more of the map, so we need less pan distance
    final double scaledMaxPanLeft = maxPanLeft * zoomLevel;
    final double scaledMaxPanRight = maxPanRight * zoomLevel;
    final double scaledMaxPanUp = maxPanUp * zoomLevel;
    final double scaledMaxPanDown = maxPanDown * zoomLevel;
    
    // Constrain the offset to the defined limits
    // X-axis: negative values = pan right, positive values = pan left
    // Y-axis: negative values = pan down, positive values = pan up
    final clampedX = newOffset.dx.clamp(-scaledMaxPanRight, scaledMaxPanLeft);
    final clampedY = newOffset.dy.clamp(-scaledMaxPanDown, scaledMaxPanUp);
    
    mapOffset = Offset(clampedX, clampedY);
    
    // Update limit flags for visual feedback
    isAtLeftLimit = clampedX >= scaledMaxPanLeft;
    isAtRightLimit = clampedX <= -scaledMaxPanRight;
    isAtTopLimit = clampedY >= scaledMaxPanUp;
    isAtBottomLimit = clampedY <= -scaledMaxPanDown;
  }
  
  // Reset map to center
  void resetMap() {
    zoomLevel = 1.0;
    mapOffset = Offset.zero;
    // Reset limit flags
    isAtLeftLimit = false;
    isAtRightLimit = false;
    isAtTopLimit = false;
    isAtBottomLimit = false;
  }
  
  // Configure pan limits (useful for adjusting constraints)
  void configurePanLimits({
    double? left,
    double? right, 
    double? up,
    double? down,
  }) {
    if (left != null) maxPanLeft = left;
    if (right != null) maxPanRight = right;
    if (up != null) maxPanUp = up;
    if (down != null) maxPanDown = down;
  }
  
  // Get current pan limits (useful for debugging)
  Map<String, double> getCurrentPanLimits() {
    // Current limits are proportional to zoom level
    return {
      'left': maxPanLeft * zoomLevel,
      'right': maxPanRight * zoomLevel,
      'up': maxPanUp * zoomLevel,
      'down': maxPanDown * zoomLevel,
      'zoomLevel': zoomLevel,
    };
  }
  
  // Filter functions
  void toggleFilterMenu() {
    showFilterMenu = !showFilterMenu;
  }

  void clearAllFilters() {
    // Machine filters
    filterEstacaoCarga = false;
    filterImpressora3d = false;
    filterImpressora = false;
    filterMaquinaCorrosao = false;
    filterEstacaoSolda = false;
    filterCNC = false;
    filterMaquinaCorte = false;
    filterBancadaReparos = false;
    
    // Beacon filters
    filterMultimetro = false;
    filterKitReparos = false;
    filterChapaMaterial = false;
    filterEstanho = false;
    filterComponentes = false;
    filterFilamento = false;
    
    // Type filters
    filterMaterial = false;
    filterFerramenta = false;
    filterMaquina = false;
    filterFuncionario = false;
    
    // Status filters
    filterEmUso = false;
    filterDisponivel = false;
    filterDescarregado = false;
    filterProcessado = false;
    filterIndisponivel = false;
    filterCarregando = false;
    filterCarregado = false;
  }

  bool hasActiveFilters() {
    return filterEstacaoCarga || filterImpressora3d || filterImpressora || 
           filterMaquinaCorrosao || filterEstacaoSolda || filterCNC || 
           filterMaquinaCorte || filterBancadaReparos || filterMultimetro || 
           filterKitReparos || filterChapaMaterial || filterEstanho || 
           filterComponentes || filterFilamento || filterMaterial || 
           filterFerramenta || filterMaquina || filterFuncionario || 
           filterEmUso || filterDisponivel || filterDescarregado || 
           filterProcessado || filterIndisponivel || filterCarregando || filterCarregado;
  }

  // Funções de gerenciamento de cache
  void clearCache() {
    _cachedMapItems = null;
    _lastFetchTime = null;
  }
  
  bool get isCacheValid {
    return _cachedMapItems != null && 
           _lastFetchTime != null && 
           DateTime.now().difference(_lastFetchTime!) < _cacheTimeout;
  }

  // Function to apply filters and close filter menu
  void confirmFilters() {
    showFilterMenu = false;
  }
  
  // Function to filter map items based on active filters
  List<MapItem> getFilteredMapItems(List<MapItem> allItems) {
    if (!hasActiveFilters() && (textController?.text.isEmpty ?? true)) {
      return allItems;
    }

    return allItems.where((item) {
      // Text search filter
      String searchText = textController?.text.toLowerCase() ?? '';
      if (searchText.isNotEmpty) {
        bool matchesText = item.name.toLowerCase().contains(searchText) ||
                          item.type.toLowerCase().contains(searchText) ||
                          item.category.toLowerCase().contains(searchText) ||
                          item.status.toLowerCase().contains(searchText);
        if (!matchesText) return false;
      }

      // Machine filters
      if (filterEstacaoCarga || filterImpressora3d || filterImpressora || 
          filterMaquinaCorrosao || filterEstacaoSolda || filterCNC || 
          filterMaquinaCorte || filterBancadaReparos) {
        
        bool matchesMachine = false;
        if (filterEstacaoCarga && item.name.toLowerCase().contains('estacao de carga')) matchesMachine = true;
        if (filterImpressora3d && item.name.toLowerCase().contains('impressora 3d')) matchesMachine = true;
        if (filterImpressora && item.name.toLowerCase().contains('impressora') && !item.name.toLowerCase().contains('3d')) matchesMachine = true;
        if (filterMaquinaCorrosao && item.name.toLowerCase().contains('corrosao')) matchesMachine = true;
        if (filterEstacaoSolda && item.name.toLowerCase().contains('solda')) matchesMachine = true;
        if (filterCNC && item.name.toLowerCase().contains('cnc')) matchesMachine = true;
        if (filterMaquinaCorte && item.name.toLowerCase().contains('corte')) matchesMachine = true;
        if (filterBancadaReparos && item.name.toLowerCase().contains('bancada')) matchesMachine = true;
        
        if (!matchesMachine) return false;
      }

      // Beacon filters
      if (filterMultimetro || filterKitReparos || filterChapaMaterial || 
          filterEstanho || filterComponentes || filterFilamento) {
        
        bool matchesBeacon = false;
        if (filterMultimetro && item.name.toLowerCase().contains('multimetro')) matchesBeacon = true;
        if (filterKitReparos && item.name.toLowerCase().contains('kit')) matchesBeacon = true;
        if (filterChapaMaterial && item.name.toLowerCase().contains('chapa')) matchesBeacon = true;
        if (filterEstanho && item.name.toLowerCase().contains('estanho')) matchesBeacon = true;
        if (filterComponentes && item.name.toLowerCase().contains('componente')) matchesBeacon = true;
        if (filterFilamento && item.name.toLowerCase().contains('filamento')) matchesBeacon = true;
        
        if (!matchesBeacon) return false;
      }

      // Type filters
      if (filterMaterial || filterFerramenta || filterMaquina || filterFuncionario) {
        bool matchesType = false;
        if (filterMaterial && item.category.toLowerCase().contains('material')) matchesType = true;
        if (filterFerramenta && item.category.toLowerCase().contains('ferramenta')) matchesType = true;
        if (filterMaquina && item.category.toLowerCase().contains('maquina')) matchesType = true;
        if (filterFuncionario && item.category.toLowerCase().contains('funcionario')) matchesType = true;

        if (!matchesType) return false;
      }

      // Status filters
      if (filterEmUso || filterDisponivel || filterDescarregado || 
          filterProcessado || filterIndisponivel || filterCarregando || filterCarregado) {
        
        bool matchesStatus = false;
        if (filterEmUso && item.status.toLowerCase().contains('uso')) matchesStatus = true;
        if (filterDisponivel && item.status.toLowerCase().contains('disponivel')) matchesStatus = true;
        if (filterDescarregado && item.status.toLowerCase().contains('descarregado')) matchesStatus = true;
        if (filterProcessado && item.status.toLowerCase().contains('processado')) matchesStatus = true;
        if (filterIndisponivel && item.status.toLowerCase().contains('indisponivel')) matchesStatus = true;
        if (filterCarregando && item.status.toLowerCase().contains('carregando')) matchesStatus = true;
        if (filterCarregado && item.status.toLowerCase().contains('carregado')) matchesStatus = true;
        
        if (!matchesStatus) return false;
      }

      return true;
    }).toList();
  }
}

class MapItem {
  final String id;
  final String name;
  final String type;
  final String category; // 'maquina', 'ferramenta', 'material', 'funcionario'
  final double x;
  final double y;
  final String status;
  final int utc;
  
  MapItem({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.x,
    required this.y,
    required this.status,
    required this.utc,
  });
}
