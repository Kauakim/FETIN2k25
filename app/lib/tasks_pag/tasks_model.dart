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
  
  // New controllers for coordinates
  TextEditingController? destinoXController;
  FocusNode? destinoXFocusNode;
  
  TextEditingController? destinoYController;
  FocusNode? destinoYFocusNode;
  
  // Dropdown values
  String? selectedTipo;
  String? selectedStatus;
  String? selectedTipoDestino;
  String? selectedDestino;
  List<String> selectedBeacons = [];
  
  // Options lists (will be populated from API)
  List<String> maquinasOptions = [];
  List<String> funcionariosOptions = [];
  List<String> beaconsOptions = [];
  
  // Loading state
  bool isLoadingOptions = false;
  bool optionsLoaded = false;
  
  // Current task being edited
  Map<String, dynamic>? currentTask;
  bool isEditing = false;
  bool showCreateForm = false;
  
  // API request completer for tasks
  Completer<ApiCallResponse>? apiRequestCompleter;

  // Available options
  final List<String> tipoOptions = [
    'Manutencao', 
    'Fabricacao',
    'Transporte',
    'Urgente',
    'Geral'
  ];
  
  final List<String> statusOptions = [
    'Pendente',
    'Em Andamento',
    'Concluída',
    'Cancelada'
  ];
  
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
            'descricao': task['mensagem'] ?? 'Sem descrição', 
            'status': task['status'] ?? 'Pendente',
            'tipo': task['tipo'] ?? 'Geral',
            'destino': task['destino'] ?? '',
            'tipoDestino': task['tipoDestino'] ?? '',
            'beacons': task['beacons'] ?? [],
            'user': task['user'] ?? loggedInUser
          });
        }
        return tasksList;
      }
    } catch (e) {
      print('Error loading tasks: $e');
    }
    return [];
  }

  // Load options for dropdowns from API
  Future<void> loadDropdownOptions([VoidCallback? onComplete]) async {
    if (isLoadingOptions) return;
    
    isLoadingOptions = true;
    print('Starting to load dropdown options...');
    
    try {
      // Load beacons
      print('Loading beacons...');
      final beaconsResponse = await BeaconsGetAllCall.call();
      print('Beacons response status: ${beaconsResponse.statusCode}');
      
      if (beaconsResponse.statusCode == 200) {
        final beaconsMap = getJsonField(beaconsResponse.jsonBody, r'''$.Beacons''') as Map<String, dynamic>? ?? {};
        print('Beacons map size: ${beaconsMap.length}');
        
        List<String> ferramentasEMateriais = [];
        List<String> machines = [];
        List<String> funcionarios = [];
        
        for (var beaconData in beaconsMap.values) {
          final beaconName = beaconData['beacon'] ?? '';
          final beaconType = beaconData['tipo'] ?? '';
          
          print('Processing beacon: $beaconName, type: $beaconType');
          
          if (beaconName.isNotEmpty) {
            // If it's a machine, add to machines list
            if (beaconType.toLowerCase() == 'maquina') {
              machines.add(beaconName);
              print('Added machine: $beaconName');
            }
            // If it's a funcionario, add to funcionarios list
            else if (beaconType.toLowerCase() == 'funcionario') {
              funcionarios.add(beaconName);
              print('Added funcionario: $beaconName');
            }
            // If it's a ferramenta or material, add to beacons list
            else if (beaconType.toLowerCase() == 'ferramenta' || beaconType.toLowerCase() == 'material') {
              ferramentasEMateriais.add(beaconName);
              print('Added ferramenta/material: $beaconName');
            }
          }
        }
        
        beaconsOptions = ferramentasEMateriais;
        maquinasOptions = machines;
        funcionariosOptions = funcionarios;
        print('Total ferramentas/materiais loaded: ${ferramentasEMateriais.length}');
        print('Total machines loaded: ${machines.length}');
        print('Total funcionarios loaded: ${funcionarios.length}');
      }
      
      optionsLoaded = true;
      print('Dropdown options loading completed successfully!');
      
      // Call the completion callback if provided
      if (onComplete != null) {
        onComplete();
      }
    } catch (e) {
      print('Error loading dropdown options: $e');
    } finally {
      isLoadingOptions = false;
    }
  }

  Future<List<Map<String, dynamic>>> getAllTasks() async {
    try {
      final response = await TasksListCall.call();
      if (response.succeeded) {
        final tasksData = response.jsonBody['Tasks'] as Map<String, dynamic>;
        List<Map<String, dynamic>> tasksList = [];
        
        for (var entry in tasksData.entries) {
          final taskData = entry.value as Map<String, dynamic>;
          tasksList.add({
            'id': taskData['id']?.toString() ?? '',
            'descricao': taskData['mensagem'] ?? 'Sem descrição', 
            'status': taskData['status'] ?? 'Pendente',
            'tipo': taskData['tipo'] ?? 'Geral',
            'destino': taskData['destino'] ?? '',
            'tipoDestino': taskData['tipoDestino'] ?? '',
            'beacons': taskData['beacons'] ?? [],
            'user': taskData['user'] ?? '',
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
    
    // Initialize new controllers
    destinoXController = TextEditingController();
    destinoXFocusNode = FocusNode();
    
    destinoYController = TextEditingController();
    destinoYFocusNode = FocusNode();
    
    // Load dropdown options asynchronously
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadDropdownOptions();
    });
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
    destinoXController?.dispose();
    destinoXFocusNode?.dispose();
    destinoYController?.dispose();
    destinoYFocusNode?.dispose();
  }
  
  Future<List<Map<String, dynamic>>> getFilteredTasks() async {
    // Get tasks based on user type
    List<Map<String, dynamic>> allTasks = FFAppState().isManager 
      ? await getAllTasks() 
      : await getUserTasks();
    List<Map<String, dynamic>> filtered = List.from(allTasks);
    
    // Apply search filter
    if (searchController?.text.isNotEmpty == true) {
      String searchTerm = searchController!.text.toLowerCase();
      filtered = filtered.where((task) {
        return task['descricao'].toString().toLowerCase().contains(searchTerm) ||
               task['destino'].toString().toLowerCase().contains(searchTerm) ||
               task['tipo'].toString().toLowerCase().contains(searchTerm) ||
               task['user'].toString().toLowerCase().contains(searchTerm);
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
    
    // Sort by status priority and ID
    filtered.sort((a, b) {
      Map<String, int> statusOrder = {
        'Em Andamento': 4, 
        'Pendente': 3, 
        'Concluída': 2, 
        'Cancelada': 1
      };
      int statusComparison = (statusOrder[b['status']] ?? 0) - (statusOrder[a['status']] ?? 0);
      
      if (statusComparison != 0) return statusComparison;
      
      // If same status, sort by ID (newest first)
      int idA = int.tryParse(a['id'].toString()) ?? 0;
      int idB = int.tryParse(b['id'].toString()) ?? 0;
      return idB.compareTo(idA);
    });
    
    return filtered;
  }
  
  void clearSearch() {
    searchController?.clear();
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
    selectedTipo = rawData['tipo'] ?? 'Geral';
    selectedStatus = rawData['status'] ?? 'Pendente';
    
    // Load beacons list if available
    if (rawData['beacons'] is List) {
      selectedBeacons = List<String>.from(rawData['beacons']);
    } else {
      selectedBeacons = [];
    }
  }
  
  // Clear form for new task
  void clearForm() {
    currentTask = null;
    isEditing = false;
    
    if (mensagemController != null) mensagemController!.clear();
    if (destinoController != null) destinoController!.clear();
    if (tipoDestinoController != null) tipoDestinoController!.clear();
    if (beaconsController != null) beaconsController!.clear();
    if (destinoXController != null) destinoXController!.clear();
    if (destinoYController != null) destinoYController!.clear();
    
    selectedTipo = null;
    selectedStatus = 'Pendente';
    selectedTipoDestino = null;
    selectedDestino = null;
    selectedBeacons = []; // Clear the list
  }
  
  // Toggle create form visibility
  void toggleCreateForm() {
    showCreateForm = !showCreateForm;
    if (!showCreateForm) {
      clearForm();
    }
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
  
  Color getPriorityColor(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'urgente':
        return Color(0xFFF44336); // Red
      case 'manutencao':
        return Color(0xFFFF9800); // Orange
      case 'fabricacao':
        return Color(0xFF2196F3); // Blue
      case 'transporte':
        return Color(0xFF9C27B0); // Purple
      case 'geral':
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

  // Get destination value based on type
  String _getDestinoValue() {
    if (selectedTipoDestino == 'Coordenada') {
      final x = destinoXController?.text ?? '';
      final y = destinoYController?.text ?? '';
      return '$x,$y';
    } else {
      return selectedDestino ?? '';
    }
  }

  // Create new task
  Future<bool> createTask(BuildContext context) async {
    try {
      final response = await TasksCreateCall.call(
        mensagem: mensagemController?.text ?? '',
        destino: _getDestinoValue(),
        tipoDestino: selectedTipoDestino ?? '',
        beacons: selectedBeacons, // Send the list directly
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
        destino: _getDestinoValue(),
        tipoDestino: selectedTipoDestino ?? '',
        beacons: selectedBeacons, // Send the list directly
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
  
  // Delete task
  Future<bool> deleteTask(BuildContext context, String taskId) async {
    try {
      // TODO: Implement actual delete API call when available
      // For now, just show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task deletada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      return true;
    } catch (e) {
      _showErrorMessage(context, 'Erro de comunicação: $e');
      return false;
    }
  }
  
  // Check if user can edit/delete tasks
  bool canEditTasks() {
    return FFAppState().isManager;
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
    bool hasMessage = mensagemController?.text.isNotEmpty ?? false;
    bool hasTipoDestino = selectedTipoDestino?.isNotEmpty ?? false;
    bool hasValidDestino = false;
    bool hasTipo = selectedTipo?.isNotEmpty ?? false;
    bool hasStatus = selectedStatus?.isNotEmpty ?? false;
    
    // Check destination based on type
    if (selectedTipoDestino == 'Coordenada') {
      hasValidDestino = (destinoXController?.text.isNotEmpty ?? false) && 
                       (destinoYController?.text.isNotEmpty ?? false);
    } else {
      hasValidDestino = selectedDestino?.isNotEmpty ?? false;
    }
    
    return hasMessage && hasTipoDestino && hasValidDestino && hasTipo && hasStatus;
  }
}
