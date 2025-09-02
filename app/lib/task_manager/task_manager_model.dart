import '/flutter_flow/flutter_flow_util.dart';
import '/backend/api_requests/api_calls.dart';
import 'task_manager_widget.dart' show TaskManagerWidget;
import 'package:flutter/material.dart';
import 'dart:async';

class TaskManagerModel extends FlutterFlowModel<TaskManagerWidget> {
  // State field(s) for search
  TextEditingController? searchController;
  FocusNode? searchFocusNode;
  
  // Filter states
  bool filterPendente = true;
  bool filterEmAndamento = true;
  bool filterConcluida = true;
  bool filterCancelada = false;
  
  // State field(s) for form
  final unfocusNode = FocusNode();
  
  // Form controllers
  TextEditingController? mensagemController;
  FocusNode? mensagemFocusNode;
  
  TextEditingController? destinoController;
  FocusNode? destinoFocusNode;
  
  TextEditingController? tipoDestinoController;
  FocusNode? tipoDestinoFocusNode;
  
  TextEditingController? beaconsController;
  FocusNode? beaconsFocusNode;
  
  TextEditingController? dependenciasController;
  FocusNode? dependenciasFocusNode;
  
  // Dropdown values
  String? selectedTipo;
  String? selectedStatus;
  
  // Current task being edited
  Map<String, dynamic>? currentTask;
  bool isEditing = false;
  bool showCreateForm = false;
  
  // API request completer for tasks
  Completer<ApiCallResponse>? apiRequestCompleter;
  
  // Available options
  final List<String> tipoOptions = [
    'Verificacao',
    'Manutencao', 
    'Calibracao',
    'Limpeza',
    'Inspecao',
    'Urgente',
    'Critico',
    'Geral'
  ];
  
  final List<String> statusOptions = [
    'Pendente',
    'Em Andamento',
    'Concluída',
    'Cancelada'
  ];

  // Get all tasks from API
  Future<List<Map<String, dynamic>>> getAllTasks() async {
    try {
      final response = await TasksListCall.call();
      if (response.succeeded) {
        final tasksData = response.jsonBody['Tasks'] as Map<String, dynamic>;
        List<Map<String, dynamic>> tasksList = [];
        
        for (var entry in tasksData.entries) {
          final taskData = entry.value as Map<String, dynamic>;
          tasksList.add({
            'id': int.tryParse(entry.key) ?? 0,
            'titulo': taskData['mensagem'] ?? 'Sem título',
            'descricao': taskData['mensagem'] ?? 'Sem descrição',
            'status': taskData['status'] ?? 'Pendente',
            'tipo': taskData['tipo'] ?? 'Geral',
            'destino': taskData['destino'] ?? '',
            'tipoDestino': taskData['tipoDestino'] ?? '',
            'beacons': taskData['beacons'] ?? [],
            'dependencias': taskData['dependencias'] ?? [],
            'user': taskData['user'] ?? '',
            'assignedTo': taskData['user'] ?? '',
            'localizacao': taskData['destino'] ?? 'Não especificado',
            'prioridade': _getPriorityFromType(taskData['tipo'] ?? 'Geral'),
            'dataCreated': '',
            'dataLimite': '',
            // Raw data for editing
            'rawData': taskData,
          });
        }
        
        // Sort by ID descending (newest first)
        tasksList.sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));
        return tasksList;
      }
    } catch (e) {
      print('Error loading tasks: $e');
    }
    
    // Return empty list if API fails
    return [];
  }

  @override
  void initState(BuildContext context) {
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    
    mensagemController = TextEditingController();
    mensagemFocusNode = FocusNode();
    
    destinoController = TextEditingController();
    destinoFocusNode = FocusNode();
    
    tipoDestinoController = TextEditingController();
    tipoDestinoFocusNode = FocusNode();
    
    beaconsController = TextEditingController();
    beaconsFocusNode = FocusNode();
    
    dependenciasController = TextEditingController();
    dependenciasFocusNode = FocusNode();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    searchController?.dispose();
    searchFocusNode?.dispose();
    mensagemController?.dispose();
    mensagemFocusNode?.dispose();
    destinoController?.dispose();
    destinoFocusNode?.dispose();
    tipoDestinoController?.dispose();
    tipoDestinoFocusNode?.dispose();
    beaconsController?.dispose();
    beaconsFocusNode?.dispose();
    dependenciasController?.dispose();
    dependenciasFocusNode?.dispose();
  }
  
  // Get filtered tasks (similar to TasksModel)
  Future<List<Map<String, dynamic>>> getFilteredTasks() async {
    List<Map<String, dynamic>> allTasks = await getAllTasks();
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
      
      // If same priority, sort by ID (newest first)
      return (b['id'] as int).compareTo(a['id'] as int);
    });
    
    return filtered;
  }
  
  // Load task data for editing
  void loadTaskForEditing(Map<String, dynamic> task) {
    currentTask = task;
    isEditing = true;
    showCreateForm = true;
    
    final rawData = task['rawData'] as Map<String, dynamic>? ?? task;
    
    mensagemController?.text = rawData['mensagem'] ?? task['titulo'] ?? '';
    destinoController?.text = rawData['destino'] ?? task['localizacao'] ?? '';
    tipoDestinoController?.text = rawData['tipoDestino'] ?? '';
    beaconsController?.text = _listToString(rawData['beacons']);
    dependenciasController?.text = _listToString(rawData['dependencias']);
    selectedTipo = rawData['tipo'] ?? 'Geral';
    selectedStatus = rawData['status'] ?? 'Pendente';
  }
  
  // Clear form for new task
  void clearForm() {
    currentTask = null;
    isEditing = false;
    
    mensagemController?.clear();
    destinoController?.clear();
    tipoDestinoController?.clear();
    beaconsController?.clear();
    dependenciasController?.clear();
    selectedTipo = null;
    selectedStatus = 'Pendente';
  }
  
  // Toggle create form visibility
  void toggleCreateForm() {
    showCreateForm = !showCreateForm;
    if (!showCreateForm) {
      clearForm();
    }
  }
  
  // Filter methods (similar to TasksModel)
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
  
  // Helper to convert list to string
  String _listToString(dynamic list) {
    if (list == null) return '';
    if (list is List) {
      return list.join(', ');
    }
    return list.toString();
  }
  
  // Helper to convert string to list
  List<String> _stringToList(String text) {
    if (text.isEmpty) return [];
    return text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
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
  
  // Create new task
  Future<bool> createTask(BuildContext context) async {
    try {
      final response = await TasksCreateCall.call(
        mensagem: mensagemController?.text ?? '',
        destino: destinoController?.text ?? '',
        tipoDestino: tipoDestinoController?.text ?? '',
        beacons: _stringToList(beaconsController?.text ?? ''),
        dependencias: _stringToList(dependenciasController?.text ?? ''),
        tipo: selectedTipo ?? 'Geral',
        status: selectedStatus ?? 'Pendente',
      );
      
      if (response.succeeded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        clearForm();
        return true;
      } else {
        _showErrorMessage(context, 'Erro ao criar task');
        return false;
      }
    } catch (e) {
      _showErrorMessage(context, 'Erro de comunicação: $e');
      return false;
    }
  }
  
  // Update existing task
  Future<bool> updateTask(BuildContext context) async {
    if (currentTask == null) return false;
    
    try {
      final response = await TasksUpdateCall.call(
        id: int.tryParse(currentTask!['id'].toString()) ?? 0,
        user: FFAppState().loggedInUser,
        mensagem: mensagemController?.text ?? '',
        destino: destinoController?.text ?? '',
        tipoDestino: tipoDestinoController?.text ?? '',
        beacons: _stringToList(beaconsController?.text ?? ''),
        dependencias: _stringToList(dependenciasController?.text ?? ''),
        tipo: selectedTipo ?? 'Geral',
        status: selectedStatus ?? 'Pendente',
      );
      
      if (response.succeeded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task atualizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        clearForm();
        return true;
      } else {
        _showErrorMessage(context, 'Erro ao atualizar task');
        return false;
      }
    } catch (e) {
      _showErrorMessage(context, 'Erro de comunicação: $e');
      return false;
    }
  }
  
  // Show error message
  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
  
  // Validate form
  bool validateForm() {
    return (mensagemController?.text.isNotEmpty ?? false) &&
           (destinoController?.text.isNotEmpty ?? false) &&
           (selectedTipo?.isNotEmpty ?? false) &&
           (selectedStatus?.isNotEmpty ?? false);
  }
}
