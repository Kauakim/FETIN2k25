import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/app_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'home_mapa_model.dart';
export 'home_mapa_model.dart';

class HomeMapaWidget extends StatefulWidget {
  const HomeMapaWidget({super.key});

  static String routeName = 'HomeMapa';
  static String routePath = '/homeMapa';

  @override
  State<HomeMapaWidget> createState() => _HomeMapaWidgetState();
}

class _HomeMapaWidgetState extends State<HomeMapaWidget> {
  late HomeMapaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  MapItem? selectedItem;
  
  // Future para controlar quando recarregar os dados
  Future<List<MapItem>>? _mapItemsFuture;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeMapaModel());
    _loadMapItems();
    _startAutoRefresh();
  }
  
  // Função para carregar dados do mapa
  void _loadMapItems() {
    _mapItemsFuture = _model.getAllMapItems();
  }
  
  // Auto refresh opcional (apenas se não há cache válido)
  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (!_model.isCacheValid) {
        _refreshMapItems();
      }
    });
  }
  
  // Função para recarregar dados (quando necessário)
  void _refreshMapItems() {
    if (mounted) {
      setState(() {
        _model.clearCache();
        _loadMapItems();
      });
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        bottomNavigationBar: AppBottomNavigation(currentIndex: 0),
        body: Stack(
          children: [
            // Map Container
            Positioned.fill(
              child: Container(
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Listener(
                      onPointerSignal: (pointerSignal) {
                        if (pointerSignal is PointerScrollEvent) {
                          // Use scroll for zoom - optimized to avoid unnecessary rebuilds
                          double zoomDelta = pointerSignal.scrollDelta.dy > 0 ? -0.1 : 0.1;
                          _model.updateZoom(_model.zoomLevel + zoomDelta);
                          if (mounted) setState(() {});
                        }
                      },
                      child: GestureDetector(
                        onScaleStart: (details) {
                          // Store initial values for pan and zoom
                        },
                        onScaleUpdate: (details) {
                          // Handle zoom and pan without triggering unnecessary rebuilds
                          _model.updateZoom(_model.zoomLevel * details.scale);
                          _model.updateOffset(details.focalPointDelta);
                          // Only setState if we need to update UI
                          if (mounted) setState(() {});
                        },
                        child: Stack(
                          children: [
                            // Map Items (Beacons and Machines) - loaded from API with caching
                            FutureBuilder<List<MapItem>>(
                              future: _mapItemsFuture,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Positioned(
                                    top: 50,
                                    left: 50,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).primary,
                                      ),
                                    ),
                                  );
                                }
                                
                                final mapItems = snapshot.data!;
                                
                                return Stack(
                                  children: [
                                    // Map Background Image - positioned with zoom and pan
                                    Positioned(
                                      left: (constraints.maxWidth / 2) - (_model.mapWidth * _model.zoomLevel / 2) + _model.mapOffset.dx,
                                      top: (constraints.maxHeight / 2) - (_model.mapHeight * _model.zoomLevel / 2) + _model.mapOffset.dy,
                                      child: Container(
                                        width: _model.mapWidth * _model.zoomLevel,
                                        height: _model.mapHeight * _model.zoomLevel,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage('assets/mapa.jpg'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                    // Map Items positioned on top of the map
                                    ...mapItems.map((item) {
                                      // Calculate position based on screen coordinates
                                      final double screenWidth = constraints.maxWidth;
                                      final double screenHeight = constraints.maxHeight;
                                      
                                      // Convert map coordinates to screen coordinates with zoom and pan
                                      final double scaledX = ((item.x * _model.zoomLevel) + _model.mapOffset.dx + (screenWidth / 2) - (_model.mapWidth * _model.zoomLevel / 2));
                                      final double scaledY = ((item.y * _model.zoomLevel) + _model.mapOffset.dy + (screenHeight / 2) - (_model.mapHeight * _model.zoomLevel / 2));
                                      
                                      return Positioned(
                                        left: scaledX - 20,
                                        top: scaledY - 20,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedItem = selectedItem?.id == item.id ? null : item;
                                            });
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: _model.getItemColor(item.category, item.status),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: selectedItem?.id == item.id 
                                                  ? FlutterFlowTheme.of(context).primary
                                                  : Colors.white,
                                                width: selectedItem?.id == item.id ? 3.0 : 2.0,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 4.0,
                                                  color: Colors.black.withValues(alpha: 0.3),
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              _model.getItemIcon(item.category),
                                              color: Colors.white,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                );
                            },
                          ),
                            
                            // Zoom level indicator
                            Positioned(
                              bottom: 20,
                              right: 20,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4.0,
                                      color: Color(0x33000000),
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '${(_model.zoomLevel * 100).toInt()}%',
                                  style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            
                            // Selected item info overlay
                            if (selectedItem != null)
                              Positioned(
                                bottom: 80,
                                left: 20,
                                right: 20,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        FlutterFlowTheme.of(context).secondaryBackground,
                                        FlutterFlowTheme.of(context).secondaryBackground.withOpacity(0.95),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 20.0,
                                        color: Color(0x26000000),
                                        offset: Offset(0, 8),
                                        spreadRadius: 0,
                                      ),
                                      BoxShadow(
                                        blurRadius: 6.0,
                                        color: Color(0x0F000000),
                                        offset: Offset(0, 2),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                    border: Border.all(
                                      color: _model.getItemColor(selectedItem!.category, selectedItem!.status).withOpacity(0.2),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Container(
                                      padding: EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Header with icon and name
                                          Row(
                                            children: [
                                              Container(
                                                width: 48,
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      _model.getItemColor(selectedItem!.category, selectedItem!.status),
                                                      _model.getItemColor(selectedItem!.category, selectedItem!.status).withOpacity(0.8),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 8.0,
                                                      color: _model.getItemColor(selectedItem!.category, selectedItem!.status).withOpacity(0.3),
                                                      offset: Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  _model.getItemIcon(selectedItem!.category),
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                              ),
                                              SizedBox(width: 16.0),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      selectedItem!.name,
                                                      style: FlutterFlowTheme.of(context).headlineSmall.copyWith(
                                                        letterSpacing: 0.0,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                    SizedBox(height: 2.0),
                                                    Text(
                                                      selectedItem!.type.isNotEmpty 
                                                        ? selectedItem!.type[0].toUpperCase() + selectedItem!.type.substring(1)
                                                        : selectedItem!.type,
                                                      style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                                        letterSpacing: 0.0,
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Status badge
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 6.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _model.getItemColor(selectedItem!.category, selectedItem!.status),
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 4.0,
                                                      color: _model.getItemColor(selectedItem!.category, selectedItem!.status).withOpacity(0.3),
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  selectedItem!.status.toUpperCase(),
                                                  style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                                    letterSpacing: 0.5,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          
                                          SizedBox(height: 16.0),
                                          
                                          // Coordenadas
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(12.0),
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).primaryBackground.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(12.0),
                                              border: Border.all(
                                                color: FlutterFlowTheme.of(context).alternate,
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  size: 18.0,
                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  'Coordenadas: (${selectedItem!.x.toInt()}, ${selectedItem!.y.toInt()})',
                                                  style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                                    letterSpacing: 0.0,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            
                            // Close button for the card
                            if (selectedItem != null)
                              Positioned(
                                bottom: 270,
                                right: 15,
                                child: Container(
                                  width: 48,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.circular(14.0),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 8.0,
                                        color: Color(0x26000000),
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedItem = null;
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(14.0),
                                      child: Center(
                                        child: Icon(
                                          Icons.close,
                                          size: 18,
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Zoom Controls - positioned in top right corner
            Positioned(
              top: 20.0,
              right: 16.0,
              child: Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8.0,
                      color: Color(0x33000000),
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Zoom In Button
                    Container(
                      width: 40.0,
                      height: 40.0,
                      child: IconButton(
                        onPressed: () {
                          _model.updateZoom(_model.zoomLevel + 0.2);
                          if (mounted) setState(() {});
                        },
                        icon: Icon(
                          Icons.zoom_in,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 20.0,
                        ),
                        tooltip: 'Aumentar Zoom',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    
                    // Center Map Button
                    Container(
                      width: 40.0,
                      height: 40.0,
                      child: IconButton(
                        onPressed: () {
                          _model.resetMap();
                          if (mounted) setState(() {});
                        },
                        icon: Icon(
                          Icons.center_focus_strong,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 20.0,
                        ),
                        tooltip: 'Centralizar Mapa',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    
                    // Zoom Out Button
                    Container(
                      width: 40.0,
                      height: 40.0,
                      child: IconButton(
                        onPressed: () {
                          _model.updateZoom(_model.zoomLevel - 0.2);
                          if (mounted) setState(() {});
                        },
                        icon: Icon(
                          Icons.zoom_out,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 20.0,
                        ),
                        tooltip: 'Diminuir Zoom',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Filter Button - positioned below zoom controls
            Positioned(
              top: 76.0,
              right: 16.0,
              child: Container(
                decoration: BoxDecoration(
                  color: _model.hasActiveFilters() 
                    ? FlutterFlowTheme.of(context).secondary
                    : FlutterFlowTheme.of(context).primary,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8.0,
                      color: Color(0x33000000),
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _model.toggleFilterMenu();
                      });
                    },
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _model.showFilterMenu ? Icons.filter_list_off : Icons.filter_list,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          SizedBox(width: 6.0),
                          Text(
                            _model.hasActiveFilters() ? 'Filtro (Ativo)' : 'Filtro',
                            style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                              color: Colors.white,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Full Screen Filter Menu Overlay
            if (_model.showFilterMenu)
              Positioned.fill(
                child: FocusableActionDetector(
                  shortcuts: {
                    LogicalKeySet(LogicalKeyboardKey.escape): DismissIntent(),
                  },
                  actions: {
                    DismissIntent: CallbackAction<DismissIntent>(
                      onInvoke: (intent) {
                        setState(() {
                          _model.showFilterMenu = false;
                        });
                        return null;
                      },
                    ),
                  },
                  autofocus: true,
                  child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: SafeArea(
                    child: Container(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      child: Column(
                        children: [
                          // Header with close button
                          Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primary,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: Color(0x33000000),
                                  offset: Offset(0.0, 2.0),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Filtros',
                                  style: FlutterFlowTheme.of(context).headlineMedium.copyWith(
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Scrollable filter content
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Pesquisa Section
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pesquisa',
                                        style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          color: FlutterFlowTheme.of(context).primary,
                                        ),
                                      ),
                                      SizedBox(height: 12.0),
                                      TextFormField(
                                        controller: _model.textController,
                                        focusNode: _model.textFieldFocusNode,
                                        onChanged: (_) async {
                                          setState(() {});
                                        },
                                        onFieldSubmitted: (_) {
                                          setState(() {
                                            _model.confirmFilters();
                                          });
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Digite para pesquisar itens...',
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 14,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).alternate,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).primary,
                                              width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: FlutterFlowTheme.of(context).error),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: FlutterFlowTheme.of(context).error),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          filled: true,
                                          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                        ),
                                        style: TextStyle(fontSize: 16),
                                        cursorColor: FlutterFlowTheme.of(context).primaryText,
                                        validator: _model.textControllerValidator != null 
                                          ? (value) => _model.textControllerValidator!(context, value)
                                          : null,
                                      ),
                                      SizedBox(height: 24.0),
                                    ],
                                  ),
                                  
                                  // Máquinas
                                  _buildFilterSection(
                                    'Máquinas',
                                    [
                                      _buildFilterChip('Estação de Carga', _model.filterEstacaoCarga, (value) {
                                        setState(() => _model.filterEstacaoCarga = value);
                                      }),
                                      _buildFilterChip('Impressora 3D', _model.filterImpressora3d, (value) {
                                        setState(() => _model.filterImpressora3d = value);
                                      }),
                                      _buildFilterChip('Impressora', _model.filterImpressora, (value) {
                                        setState(() => _model.filterImpressora = value);
                                      }),
                                      _buildFilterChip('Máquina de Corrosão', _model.filterMaquinaCorrosao, (value) {
                                        setState(() => _model.filterMaquinaCorrosao = value);
                                      }),
                                      _buildFilterChip('Estação de Solda', _model.filterEstacaoSolda, (value) {
                                        setState(() => _model.filterEstacaoSolda = value);
                                      }),
                                      _buildFilterChip('CNC', _model.filterCNC, (value) {
                                        setState(() => _model.filterCNC = value);
                                      }),
                                      _buildFilterChip('Máquina de Corte', _model.filterMaquinaCorte, (value) {
                                        setState(() => _model.filterMaquinaCorte = value);
                                      }),
                                      _buildFilterChip('Bancada de Reparos e Carga', _model.filterBancadaReparos, (value) {
                                        setState(() => _model.filterBancadaReparos = value);
                                      }),
                                    ],
                                  ),
                                  
                                  // Beacons
                                  _buildFilterSection(
                                    'Beacons',
                                    [
                                      _buildFilterChip('Multímetro', _model.filterMultimetro, (value) {
                                        setState(() => _model.filterMultimetro = value);
                                      }),
                                      _buildFilterChip('Kit de Reparos', _model.filterKitReparos, (value) {
                                        setState(() => _model.filterKitReparos = value);
                                      }),
                                      _buildFilterChip('Chapa de Material', _model.filterChapaMaterial, (value) {
                                        setState(() => _model.filterChapaMaterial = value);
                                      }),
                                      _buildFilterChip('Estanho', _model.filterEstanho, (value) {
                                        setState(() => _model.filterEstanho = value);
                                      }),
                                      _buildFilterChip('Componentes', _model.filterComponentes, (value) {
                                        setState(() => _model.filterComponentes = value);
                                      }),
                                      _buildFilterChip('Filamento', _model.filterFilamento, (value) {
                                        setState(() => _model.filterFilamento = value);
                                      }),
                                    ],
                                  ),
                                  
                                  // Tipos
                                  _buildFilterSection(
                                    'Tipos',
                                    [
                                      _buildFilterChip('Material', _model.filterMaterial, (value) {
                                        setState(() => _model.filterMaterial = value);
                                      }),
                                      _buildFilterChip('Ferramenta', _model.filterFerramenta, (value) {
                                        setState(() => _model.filterFerramenta = value);
                                      }),
                                    ],
                                  ),
                                  
                                  // Status
                                  _buildFilterSection(
                                    'Status',
                                    [
                                      _buildFilterChip('Em Uso', _model.filterEmUso, (value) {
                                        setState(() => _model.filterEmUso = value);
                                      }),
                                      _buildFilterChip('Disponível', _model.filterDisponivel, (value) {
                                        setState(() => _model.filterDisponivel = value);
                                      }),
                                      _buildFilterChip('Descarregado', _model.filterDescarregado, (value) {
                                        setState(() => _model.filterDescarregado = value);
                                      }),
                                      _buildFilterChip('Processado', _model.filterProcessado, (value) {
                                        setState(() => _model.filterProcessado = value);
                                      }),
                                      _buildFilterChip('Indisponível', _model.filterIndisponivel, (value) {
                                        setState(() => _model.filterIndisponivel = value);
                                      }),
                                      _buildFilterChip('Carregando', _model.filterCarregando, (value) {
                                        setState(() => _model.filterCarregando = value);
                                      }),
                                      _buildFilterChip('Carregado', _model.filterCarregado, (value) {
                                        setState(() => _model.filterCarregado = value);
                                      }),
                                    ],
                                  ),
                                  
                                  SizedBox(height: 20.0),
                                ],
                              ),
                            ),
                          ),
                          
                          // Apply/Close buttons at bottom
                          Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              border: Border(
                                top: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                // Main confirm button (takes most space)
                                Expanded(
                                  flex: 5,
                                  child: FFButtonWidget(
                                    onPressed: () {
                                      setState(() {
                                        _model.confirmFilters();
                                        // Força re-render do FutureBuilder sem nova API call
                                        _loadMapItems();
                                      });
                                    },
                                    text: 'Confirmar Filtros',
                                    options: FFButtonOptions(
                                      height: 48.0,
                                      color: FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context).titleMedium.copyWith(
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      elevation: 2.0,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.0),
                                // Clear filters button with trash icon (smaller)
                                Container(
                                  height: 48.0,
                                  width: 48.0,
                                  child: FFButtonWidget(
                                    onPressed: () {
                                      setState(() {
                                        _model.clearAllFilters();
                                        // Força re-render do FutureBuilder sem nova API call
                                        _loadMapItems();
                                      });
                                    },
                                    text: '',
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                    options: FFButtonOptions(
                                      height: 48.0,
                                      width: 48.0,
                                      color: FlutterFlowTheme.of(context).error,
                                      textStyle: FlutterFlowTheme.of(context).titleMedium.copyWith(
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      elevation: 2.0,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper method to build filter sections
  Widget _buildFilterSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: FlutterFlowTheme.of(context).titleLarge.copyWith(
            letterSpacing: 0.0,
            fontWeight: FontWeight.bold,
            color: FlutterFlowTheme.of(context).primary,
          ),
        ),
        SizedBox(height: 12.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: children,
        ),
        SizedBox(height: 24.0),
      ],
    );
  }

  // Helper method to build filter chips
  Widget _buildFilterChip(String label, bool isSelected, Function(bool) onChanged) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onChanged,
      selectedColor: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
      checkmarkColor: FlutterFlowTheme.of(context).primary,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      side: BorderSide(
        color: isSelected 
          ? FlutterFlowTheme.of(context).primary
          : FlutterFlowTheme.of(context).alternate,
        width: 1.0,
      ),
      labelStyle: TextStyle(
        color: isSelected 
          ? FlutterFlowTheme.of(context).primary
          : FlutterFlowTheme.of(context).primaryText,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

// Custom painter for grid background

