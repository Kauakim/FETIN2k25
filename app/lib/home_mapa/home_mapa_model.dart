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
  double mapWidth = 800.0;
  double mapHeight = 600.0;
  
  // Pan limits (how far the map can be dragged in each direction)
  double maxPanLeft = 200.0;   // Maximum distance to pan left
  double maxPanRight = 200.0;  // Maximum distance to pan right
  double maxPanUp = 150.0;     // Maximum distance to pan up
  double maxPanDown = 150.0;   // Maximum distance to pan down
  
  // Track if we're at pan limits (for visual feedback)
  bool isAtLeftLimit = false;
  bool isAtRightLimit = false;
  bool isAtTopLimit = false;
  bool isAtBottomLimit = false;
  
  // API request completer for beacons
  Completer<ApiCallResponse>? apiRequestCompleter;
  
  // Fixed machines data with coordinates
  List<MapItem> fixedMachines = [
    MapItem(
      id: 'M001',
      name: 'Estacao de carga',
      type: 'maquina',
      category: 'maquina',
      x: 100.0,
      y: 300.0,
      status: 'ativo',
      linha: 'Carregamento',
    ),
    MapItem(
      id: 'M002',
      name: 'Impressora 3D',
      type: 'maquina',
      category: 'maquina',
      x: 150.0,
      y: 150.0,
      status: 'ativo',
      linha: 'Maker',
    ),
    MapItem(
      id: 'M003',
      name: 'Impressora',
      type: 'maquina',
      category: 'maquina',
      x: 250.0,
      y: 150.0,
      status: 'ativo',
      linha: 'Maker',
    ),
    MapItem(
      id: 'M004',
      name: 'Maquina de corrosao',
      type: 'maquina',
      category: 'maquina',
      x: 400.0,
      y: 200.0,
      status: 'ativo',
      linha: 'PCB',
    ),
    MapItem(
      id: 'M005',
      name: 'Estacao de solda',
      type: 'maquina',
      category: 'maquina',
      x: 500.0,
      y: 100.0,
      status: 'ativo',
      linha: 'PCB',
    ),
    MapItem(
      id: 'M006',
      name: 'CNC',
      type: 'maquina',
      category: 'maquina',
      x: 350.0,
      y: 350.0,
      status: 'ativo',
      linha: 'Corte',
    ),
    MapItem(
      id: 'M007',
      name: 'Maquina de corte',
      type: 'maquina',
      category: 'maquina',
      x: 550.0,
      y: 350.0,
      status: 'ativo',
      linha: 'Corte',
    ),
    MapItem(
      id: 'M008',
      name: 'Bancada de reparos e carga',
      type: 'maquina',
      category: 'maquina',
      x: 600.0,
      y: 250.0,
      status: 'ativo',
      linha: 'Manutencao',
    ),
  ];
  
  // Get all map items (fixed machines + dynamic beacons)
  Future<List<MapItem>> getAllMapItems() async {
    List<MapItem> allItems = List.from(fixedMachines);
    
    try {
      final apiResponse = await BeaconsGetAllCall.call();
      if (apiResponse.statusCode == 200) {
        final beaconsMap = getJsonField(apiResponse.jsonBody, r'''$.Beacons''') as Map<String, dynamic>? ?? {};
        
        for (var beaconData in beaconsMap.values) {
          // Determine category based on beacon type
          String category = _getCategoryFromBeaconType(beaconData['tipo'] ?? '');
          
          allItems.add(MapItem(
            id: beaconData['id']?.toString() ?? '',
            name: beaconData['beacon'] ?? '',
            type: category,
            category: category,
            x: (beaconData['x']?.toDouble() ?? 0.0) * 50.0, // Scale coordinates
            y: (beaconData['y']?.toDouble() ?? 0.0) * 50.0, // Scale coordinates
            status: beaconData['status'] ?? 'disponivel',
          ));
        }
      }
    } catch (e) {
      print('Error loading beacons: $e');
    }
    
    return allItems;
  }
  
  // Determine category from beacon type
  String _getCategoryFromBeaconType(String tipo) {
    tipo = tipo.toLowerCase();
    if (tipo.contains('ferramenta') || tipo.contains('multimetro') || tipo.contains('kit')) {
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
  void initState(BuildContext context) {}

  @override
  void dispose() {}
  
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
}

class MapItem {
  final String id;
  final String name;
  final String type;
  final String category; // 'maquina', 'ferramenta', 'material', 'pessoa'
  final double x;
  final double y;
  final String status;
  final String? linha; // Para máquinas
  
  MapItem({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.x,
    required this.y,
    required this.status,
    this.linha,
  });
}
