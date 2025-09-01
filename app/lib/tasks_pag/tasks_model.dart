import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'tasks_widget.dart' show TasksWidget;
import 'package:flutter/material.dart';
import 'dart:async';

class TasksModel extends FlutterFlowModel<TasksWidget> {
  // State field(s) for search
  TextEditingController? searchController;
  FocusNode? searchFocusNode;
  
  // Filter states
  bool filterPendente = true;
  bool filterEmAndamento = true;
  bool filterConcluida = true;
  bool filterCancelada = false;
  
  // API request completer for tasks
  Completer<ApiCallResponse>? apiRequestCompleter;
  
  // Get tasks from API for the logged-in user
  Future<List<Map<String, dynamic>>> getUserTasks() async {
    final loggedInUser = FFAppState().loggedInUser;
    if (loggedInUser.isEmpty) {
      return [];
    }
    
    try {
      final apiResponse = await TasksGetByUserCall.call(username: loggedInUser);
      if (apiResponse.statusCode == 200) {
        final tasksMap = getJsonField(apiResponse.jsonBody, r'''$.Tasks''') as Map<String, dynamic>? ?? {};
        
        List<Map<String, dynamic>> tasksList = [];
        for (var taskData in tasksMap.values) {
          final task = taskData as Map<String, dynamic>;
          tasksList.add({
            'id': task['id']?.toString() ?? '',
            'titulo': task['mensagem'] ?? 'Sem título',
            'descricao': task['mensagem'] ?? 'Sem descrição', 
            'status': task['status'] ?? 'Pendente',
            'tipo': task['tipo'] ?? 'Geral',
            'destino': task['destino'] ?? '',
            'tipoDestino': task['tipoDestino'] ?? '',
            'beacons': task['beacons'] ?? [],
            'dependencias': task['dependencias'] ?? [],
            'user': task['user'] ?? loggedInUser,
            'assignedTo': task['user'] ?? loggedInUser,
            'localizacao': task['destino'] ?? 'Não especificado',
            // Campos para compatibilidade com UI existente
            'prioridade': _getPriorityFromType(task['tipo'] ?? 'Geral'),
            'dataCreated': '',
            'dataLimite': '',
          });
        }
        return tasksList;
      }
    } catch (e) {
      print('Error loading tasks: $e');
    }
    
    // Fallback mock data if API fails
    return _getMockTasks();
  }
  
  // Mock data for fallback
  List<Map<String, dynamic>> _getMockTasks() {
    return [
      {
        'id': '1',
        'titulo': 'Verificar Beacon B001',
        'descricao': 'Verificar funcionamento do beacon na estação de carga',
        'status': 'Pendente',
        'tipo': 'Verificacao',
        'destino': 'Estação de Carga 1',
        'tipoDestino': 'Local',
        'beacons': ['B001'],
        'dependencias': [],
        'user': FFAppState().loggedInUser,
        'assignedTo': FFAppState().loggedInUser,
        'localizacao': 'Estação de Carga 1',
        'prioridade': 'Alta',
        'dataCreated': '2025-08-27',
        'dataLimite': '2025-08-28',
      },
      {
        'id': '2',
        'titulo': 'Manutenção Impressora 3D',
        'descricao': 'Realizar manutenção preventiva na impressora 3D',
        'status': 'Em Andamento',
        'tipo': 'Manutencao',
        'destino': 'Lab de Prototipagem',
        'tipoDestino': 'Departamento',
        'beacons': ['B003'],
        'dependencias': [],
        'user': FFAppState().loggedInUser,
        'assignedTo': FFAppState().loggedInUser,
        'localizacao': 'Lab de Prototipagem',
        'prioridade': 'Média',
        'dataCreated': '2025-08-26',
        'dataLimite': '2025-08-29',
      },
      {
        'id': '3',
        'titulo': 'Calibração CNC',
        'descricao': 'Calibrar máquina CNC após substituição de peças',
        'status': 'Concluída',
        'tipo': 'Calibracao',
        'destino': 'Oficina Mecânica',
        'tipoDestino': 'Setor',
        'beacons': ['B002'],
        'dependencias': ['2'],
        'user': FFAppState().loggedInUser,
        'assignedTo': FFAppState().loggedInUser,
        'localizacao': 'Oficina Mecânica',
        'prioridade': 'Alta',
        'dataCreated': '2025-08-25',
        'dataLimite': '2025-08-26',
      },
    ];
  }

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
  
  Future<List<Map<String, dynamic>>> getFilteredTasks() async {
    List<Map<String, dynamic>> allTasks = await getUserTasks();
    List<Map<String, dynamic>> filtered = List.from(allTasks);
    
    // Apply search filter
    if (searchController?.text.isNotEmpty == true) {
      String searchTerm = searchController!.text.toLowerCase();
      filtered = filtered.where((task) {
        return task['titulo'].toString().toLowerCase().contains(searchTerm) ||
               task['descricao'].toString().toLowerCase().contains(searchTerm) ||
               task['localizacao'].toString().toLowerCase().contains(searchTerm) ||
               task['assignedTo'].toString().toLowerCase().contains(searchTerm);
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
  
  // Helper method to determine priority from task type
  String _getPriorityFromType(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'urgente':
      case 'critico':
        return 'Alta';
      case 'manutencao':
      case 'verificacao':
        return 'Média';
      default:
        return 'Baixa';
    }
  }
}
