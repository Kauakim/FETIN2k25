import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/app_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeMapaModel());
  }

  @override
  void dispose() {
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
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Mapa da Fábrica',
            style: FlutterFlowTheme.of(context).headlineMedium.copyWith(
              color: Colors.white,
              fontSize: 22.0,
              letterSpacing: 0.0,
            ),
          ),
          actions: [
            // Zoom controls
            IconButton(
              onPressed: () {
                setState(() {
                  _model.updateZoom(_model.zoomLevel + 0.2);
                });
              },
              icon: Icon(Icons.zoom_in, color: Colors.white),
              tooltip: 'Aumentar Zoom',
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _model.updateZoom(_model.zoomLevel - 0.2);
                });
              },
              icon: Icon(Icons.zoom_out, color: Colors.white),
              tooltip: 'Diminuir Zoom',
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _model.resetMap();
                });
              },
              icon: Icon(Icons.center_focus_strong, color: Colors.white),
              tooltip: 'Centralizar Mapa',
            ),
          ],
          centerTitle: false,
          elevation: 2.0,
        ),
        bottomNavigationBar: AppBottomNavigation(currentIndex: 0),
        body: Column(
          children: [
            // Map Container
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Listener(
                      onPointerSignal: (pointerSignal) {
                        if (pointerSignal is PointerScrollEvent) {
                          setState(() {
                            // Use scroll for zoom - scroll up = zoom in, scroll down = zoom out
                            double zoomDelta = pointerSignal.scrollDelta.dy > 0 ? -0.1 : 0.1;
                            _model.updateZoom(_model.zoomLevel + zoomDelta);
                          });
                        }
                      },
                      child: GestureDetector(
                        onScaleStart: (details) {
                          // Store initial values for pan and zoom
                        },
                        onScaleUpdate: (details) {
                          setState(() {
                            // Handle zoom
                            if (details.scale != 1.0) {
                              _model.updateZoom(_model.zoomLevel * details.scale);
                            }
                            // Handle pan - only move the viewport, not the map
                            _model.updateOffset(details.focalPointDelta);
                          });
                        },
                        child: Stack(
                          children: [
                            // Fixed Map Background - fills entire screen
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: CustomPaint(
                                  size: Size(constraints.maxWidth, constraints.maxHeight),
                                  painter: GridPainter(),
                                ),
                              ),
                            ),
                          
                            // Map Items (Beacons and Machines) - loaded from API
                            FutureBuilder<List<MapItem>>(
                              future: _model.getAllMapItems(),
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
                                  children: mapItems.map((item) {
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
                                  padding: EdgeInsets.all(16.0),
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
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: _model.getItemColor(
                                            selectedItem!.category, 
                                            selectedItem!.status
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          _model.getItemIcon(selectedItem!.category),
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                      SizedBox(width: 12.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              selectedItem!.name,
                                              style: FlutterFlowTheme.of(context).titleMedium.copyWith(
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4.0),
                                            Row(
                                              children: [
                                                Text(
                                                  'Tipo: ',
                                                  style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  selectedItem!.type,
                                                  style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                                    letterSpacing: 0.0,
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (selectedItem!.linha != null)
                                              Row(
                                                children: [
                                                  Text(
                                                    'Linha: ',
                                                    style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    selectedItem!.linha!,
                                                    style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                                      letterSpacing: 0.0,
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Status: ',
                                                  style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 6.0,
                                                    vertical: 2.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: _model.getItemColor(
                                                      selectedItem!.category, 
                                                      selectedItem!.status
                                                    ).withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(4.0),
                                                    border: Border.all(
                                                      color: _model.getItemColor(
                                                        selectedItem!.category, 
                                                        selectedItem!.status
                                                      ),
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    selectedItem!.status.toUpperCase(),
                                                    style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                                      letterSpacing: 0.0,
                                                      fontSize: 10.0,
                                                      fontWeight: FontWeight.bold,
                                                      color: _model.getItemColor(
                                                        selectedItem!.category, 
                                                        selectedItem!.status
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Posição: ',
                                                  style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  '(${selectedItem!.x.toInt()}, ${selectedItem!.y.toInt()})',
                                                  style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                                                    letterSpacing: 0.0,
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                    fontFamily: 'monospace',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedItem = null;
                                          });
                                        },
                                        icon: Icon(Icons.close, size: 20),
                                        tooltip: 'Fechar',
                                      ),
                                    ],
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
          ],
        ),
      ),
    );
  }
}

// Custom painter for grid background
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 1.0;

    const gridSize = 50.0;

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
