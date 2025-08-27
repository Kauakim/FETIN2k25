import '/flutter_flow/flutter_flow_util.dart';
import 'home_mapa_widget.dart' show HomeMapaWidget;
import 'package:flutter/material.dart';

class HomeMapaModel extends FlutterFlowModel<HomeMapaWidget> {
  // Map control variables
  double zoomLevel = 1.0;
  double minZoom = 0.5;
  double maxZoom = 3.0;
  Offset mapOffset = Offset.zero;
  
  // Map image dimensions (to be used as reference for coordinate system)
  double mapWidth = 800.0;
  double mapHeight = 600.0;
  
  // Beacons and machines data with coordinates
  List<MapItem> mapItems = [
    // Máquinas
    MapItem(
      id: 'M001',
      name: 'Estação de Carga 1',
      type: 'Estacao de Carga',
      category: 'maquina',
      x: 100.0,
      y: 150.0,
      status: 'ativo',
    ),
    MapItem(
      id: 'M002',
      name: 'Impressora 3D',
      type: 'Impressora 3D',
      category: 'maquina',
      x: 300.0,
      y: 200.0,
      status: 'ativo',
    ),
    MapItem(
      id: 'M003',
      name: 'CNC Principal',
      type: 'CNC',
      category: 'maquina',
      x: 500.0,
      y: 180.0,
      status: 'manutencao',
    ),
    MapItem(
      id: 'M004',
      name: 'Estação de Solda',
      type: 'Estacao de Solda',
      category: 'maquina',
      x: 200.0,
      y: 350.0,
      status: 'ativo',
    ),
    MapItem(
      id: 'M005',
      name: 'Máquina de Corte',
      type: 'Maquina de Corte',
      category: 'maquina',
      x: 600.0,
      y: 300.0,
      status: 'inativo',
    ),
    
    // Beacons/Ferramentas
    MapItem(
      id: 'B001',
      name: 'Multímetro Digital',
      type: 'Multimetro',
      category: 'beacon',
      x: 150.0,
      y: 250.0,
      status: 'disponivel',
    ),
    MapItem(
      id: 'B002',
      name: 'Kit de Reparos',
      type: 'Kit Reparos',
      category: 'beacon',
      x: 400.0,
      y: 120.0,
      status: 'em_uso',
    ),
    MapItem(
      id: 'B003',
      name: 'Chapa de Alumínio',
      type: 'Chapa Material',
      category: 'beacon',
      x: 550.0,
      y: 400.0,
      status: 'disponivel',
    ),
    MapItem(
      id: 'B004',
      name: 'Estanho',
      type: 'Estanho',
      category: 'beacon',
      x: 250.0,
      y: 380.0,
      status: 'baixo_estoque',
    ),
    MapItem(
      id: 'B005',
      name: 'Filamento PLA',
      type: 'Filamento',
      category: 'beacon',
      x: 320.0,
      y: 220.0,
      status: 'disponivel',
    ),
  ];

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
  
  // Get icon for different types
  IconData getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'estacao de carga':
        return Icons.battery_charging_full;
      case 'impressora 3d':
        return Icons.view_in_ar;
      case 'cnc':
        return Icons.precision_manufacturing;
      case 'estacao de solda':
        return Icons.construction;
      case 'maquina de corte':
        return Icons.content_cut;
      case 'multimetro':
        return Icons.electrical_services;
      case 'kit reparos':
        return Icons.build;
      case 'chapa material':
        return Icons.rectangle;
      case 'estanho':
        return Icons.circle;
      case 'filamento':
        return Icons.cable;
      default:
        return Icons.device_unknown;
    }
  }
  
  // Get color based on category and status
  Color getItemColor(String category, String status) {
    if (category == 'maquina') {
      switch (status.toLowerCase()) {
        case 'ativo':
          return Color(0xFF4CAF50); // Green
        case 'inativo':
          return Color(0xFF757575); // Grey
        case 'manutencao':
          return Color(0xFFF44336); // Red
        default:
          return Color(0xFF2196F3); // Blue
      }
    } else {
      switch (status.toLowerCase()) {
        case 'disponivel':
          return Color(0xFF4CAF50); // Green
        case 'em_uso':
          return Color(0xFFFF9800); // Orange
        case 'baixo_estoque':
          return Color(0xFFF44336); // Red
        case 'manutencao':
          return Color(0xFF9C27B0); // Purple
        default:
          return Color(0xFF2196F3); // Blue
      }
    }
  }
  
  // Update zoom level
  void updateZoom(double newZoom) {
    zoomLevel = newZoom.clamp(minZoom, maxZoom);
  }
  
  // Update map offset for panning (constrained to keep items visible)
  void updateOffset(Offset delta) {
    mapOffset += delta;
    // Optional: Add constraints to prevent panning too far
    // This keeps the beacons within reasonable bounds
  }
  
  // Reset map to center
  void resetMap() {
    zoomLevel = 1.0;
    mapOffset = Offset.zero;
  }
}

class MapItem {
  final String id;
  final String name;
  final String type;
  final String category; // 'maquina' ou 'beacon'
  final double x;
  final double y;
  final String status;
  
  MapItem({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.x,
    required this.y,
    required this.status,
  });
}
