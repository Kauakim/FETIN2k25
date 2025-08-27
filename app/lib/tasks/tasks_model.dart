import '/flutter_flow/flutter_flow_util.dart';
import 'tasks_widget.dart' show TasksWidget;
import 'package:flutter/material.dart';

class TasksModel extends FlutterFlowModel<TasksWidget> {
  // State field(s) for search
  TextEditingController? searchController;
  FocusNode? searchFocusNode;
  
  // Filter states
  bool filterPendente = true;
  bool filterEmAndamento = true;
  bool filterConcluida = true;
  bool filterCancelada = false;
  
  // Mock data for tasks
  List<Map<String, dynamic>> _allTasks = [
    {
      'id': 1,
      'titulo': 'Verificar Beacon B001',
      'descricao': 'Verificar funcionamento do beacon na estação de carga',
      'status': 'Pendente',
      'prioridade': 'Alta',
      'dataCreated': '2025-08-27',
      'dataLimite': '2025-08-28',
      'localizacao': 'Estação de Carga 1',
      'beacon': 'B001'
    },
    {
      'id': 2,
      'titulo': 'Manutenção Impressora 3D',
      'descricao': 'Realizar manutenção preventiva na impressora 3D',
      'status': 'Em Andamento',
      'prioridade': 'Média',
      'dataCreated': '2025-08-26',
      'dataLimite': '2025-08-29',
      'localizacao': 'Lab de Prototipagem',
      'beacon': 'B003'
    },
    {
      'id': 3,
      'titulo': 'Calibração CNC',
      'descricao': 'Calibrar máquina CNC após substituição de peças',
      'status': 'Concluída',
      'prioridade': 'Alta',
      'dataCreated': '2025-08-25',
      'dataLimite': '2025-08-26',
      'localizacao': 'Oficina Mecânica',
      'beacon': 'B007'
    },
    {
      'id': 4,
      'titulo': 'Reposição de Estanho',
      'descricao': 'Repor estoque de estanho na estação de solda',
      'status': 'Pendente',
      'prioridade': 'Baixa',
      'dataCreated': '2025-08-27',
      'dataLimite': '2025-08-30',
      'localizacao': 'Estação de Solda',
      'beacon': 'B005'
    },
    {
      'id': 5,
      'titulo': 'Inspeção de Qualidade',
      'descricao': 'Realizar inspeção de qualidade nos componentes produzidos',
      'status': 'Em Andamento',
      'prioridade': 'Média',
      'dataCreated': '2025-08-26',
      'dataLimite': '2025-08-28',
      'localizacao': 'Bancada de Controle',
      'beacon': 'B009'
    }
  ];

  @override
  void initState(BuildContext context) {
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    searchController?.dispose();
    searchFocusNode?.dispose();
  }
  
  List<Map<String, dynamic>> getFilteredTasks() {
    List<Map<String, dynamic>> filtered = List.from(_allTasks);
    
    // Apply search filter
    if (searchController?.text.isNotEmpty == true) {
      String searchTerm = searchController!.text.toLowerCase();
      filtered = filtered.where((task) {
        return task['titulo'].toString().toLowerCase().contains(searchTerm) ||
               task['descricao'].toString().toLowerCase().contains(searchTerm) ||
               task['localizacao'].toString().toLowerCase().contains(searchTerm) ||
               task['beacon'].toString().toLowerCase().contains(searchTerm);
      }).toList();
    }
    
    // Apply status filters
    filtered = filtered.where((task) {
      String status = task['status'].toString().toLowerCase();
      return (filterPendente && status == 'pendente') ||
             (filterEmAndamento && status == 'em andamento') ||
             (filterConcluida && status == 'concluída') ||
             (filterCancelada && status == 'cancelada');
    }).toList();
    
    // Sort by priority and date
    filtered.sort((a, b) {
      Map<String, int> priorityOrder = {'Alta': 3, 'Média': 2, 'Baixa': 1};
      int priorityComparison = (priorityOrder[b['prioridade']] ?? 0) - (priorityOrder[a['prioridade']] ?? 0);
      
      if (priorityComparison != 0) return priorityComparison;
      
      // If same priority, sort by deadline
      return a['dataLimite'].toString().compareTo(b['dataLimite'].toString());
    });
    
    return filtered;
  }
  
  void clearSearch() {
    searchController?.clear();
  }
  
  void toggleFilter(String filterType) {
    switch (filterType) {
      case 'pendente':
        filterPendente = !filterPendente;
        break;
      case 'emAndamento':
        filterEmAndamento = !filterEmAndamento;
        break;
      case 'concluida':
        filterConcluida = !filterConcluida;
        break;
      case 'cancelada':
        filterCancelada = !filterCancelada;
        break;
    }
  }
  
  bool hasActiveFilters() {
    return !filterPendente || !filterEmAndamento || !filterConcluida || filterCancelada;
  }
  
  void clearAllFilters() {
    filterPendente = true;
    filterEmAndamento = true;
    filterConcluida = true;
    filterCancelada = false;
  }
  
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pendente':
        return Color(0xFFFF9800); // Orange
      case 'em andamento':
        return Color(0xFF2196F3); // Blue
      case 'concluída':
        return Color(0xFF4CAF50); // Green
      case 'cancelada':
        return Color(0xFFF44336); // Red
      default:
        return Color(0xFF757575); // Grey
    }
  }
  
  Color getPriorityColor(String prioridade) {
    switch (prioridade.toLowerCase()) {
      case 'alta':
        return Color(0xFFF44336); // Red
      case 'média':
        return Color(0xFFFF9800); // Orange
      case 'baixa':
        return Color(0xFF4CAF50); // Green
      default:
        return Color(0xFF757575); // Grey
    }
  }
}
