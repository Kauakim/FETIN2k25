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
        tasksList.sort((a, b) {
          int idA = int.tryParse(a['id'].toString()) ?? 0;
          int idB = int.tryParse(b['id'].toString()) ?? 0;
          return idB.compareTo(idA);
        });
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
    
    // Initialize dropdown selections with default values
    selectedStatus = 'Pendente';
    selectedTipo = 'Geral';
    
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
    
    // Pre-fill all form fields with existing data
    mensagemController?.text = rawData['mensagem'] ?? task['titulo'] ?? '';
    destinoController?.text = rawData['destino'] ?? task['localizacao'] ?? '';
    tipoDestinoController?.text = rawData['tipoDestino'] ?? '';
    beaconsController?.text = _listToString(rawData['beacons']);
    selectedTipo = rawData['tipo'] ?? 'Geral';
    selectedStatus = rawData['status'] ?? 'Pendente';
    
    // Set tipo de destino
    selectedTipoDestino = rawData['tipoDestino'];
    
    // Handle destino based on tipo
    if (selectedTipoDestino == 'Coordenada') {
      final coords = rawData['destino']?.toString().split(',');
      if (coords != null && coords.length >= 2) {
        destinoXController?.text = coords[0].trim();
        destinoYController?.text = coords[1].trim();
      }
    } else {
      selectedDestino = rawData['destino'];
    }
    
    // Load beacons list if available
    if (rawData['beacons'] is List) {
      selectedBeacons = List<String>.from(rawData['beacons']);
    } else {
      selectedBeacons = [];
    }
    
    print('Loaded task for editing: ${rawData}');
    print('Form fields pre-filled - Mensagem: ${mensagemController?.text}, Destino: ${destinoController?.text}');
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
    
    selectedTipo = 'Geral';
    selectedStatus = 'Pendente';
    selectedTipoDestino = null;
    selectedDestino = null;
    selectedBeacons = []; // Clear the list
  }
  
  // Toggle create form visibility
  void toggleCreateForm() {
    showCreateForm = !showCreateForm;
    if (!showCreateForm && !isEditing) {
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
    // Validate the form before creating
    final validationError = getValidationError();
    if (validationError != null) {
      if (context.mounted) {
        _showErrorMessage(context, validationError);
      }
      return false;
    }
    
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
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Task criada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        clearForm();
        return true;
      } else {
        if (context.mounted) {
          _showErrorMessage(context, 'Erro ao criar task');
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorMessage(context, 'Erro de comunicação: $e');
      }
      return false;
    }
  }
  
  // Update existing task
  Future<bool> updateTask(BuildContext context) async {
    if (currentTask == null) return false;
    
    // Validate the form before updating
    final validationError = getValidationError();
    if (validationError != null) {
      if (context.mounted) {
        _showErrorMessage(context, validationError);
      }
      return false;
    }
    
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
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Task atualizada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        clearForm();
        return true;
      } else {
        if (context.mounted) {
          _showErrorMessage(context, 'Erro ao atualizar task');
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorMessage(context, 'Erro de comunicação: $e');
      }
      return false;
    }
  }
  
  // Delete task
  Future<bool> deleteTask(BuildContext context, String taskId) async {
    try {
      // Convert taskId to int
      final id = int.tryParse(taskId);
      if (id == null) {
        if (context.mounted) {
          _showErrorMessage(context, 'ID da task inválido');
        }
        return false;
      }

      print('Attempting to delete task with ID: $id');
      final response = await TasksDeleteCall.call(id: id);
      
      print('Delete response - Status: ${response.statusCode}');
      print('Delete response - Success: ${response.succeeded}');
      print('Delete response - Body: ${response.jsonBody}');
      
      // Check for successful deletion - sometimes the task is deleted even with 404
      if (response.succeeded || response.statusCode == 200) {
        print('Task deleted successfully from server');
        
        // Only refresh if the widget is still mounted
        if (context.mounted) {
          try {
            // Refresh the task list automatically
            await getAllTasks();
            
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Task deletada com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
          } catch (e) {
            print('Error refreshing tasks after delete: $e');
          }
        }
        
        return true;
      } else {
        // Even if we get 404, the task might have been deleted, so let's refresh and check
        print('Got error response, but checking if task was actually deleted...');
        
        if (context.mounted) {
          try {
            await getAllTasks();
            
            // Show a more neutral message since we're not sure
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Operação de delete executada. Verificando resultado...'),
                backgroundColor: Colors.orange,
              ),
            );
          } catch (e) {
            print('Error refreshing tasks after delete: $e');
          }
        }
        
        return true; // Return true to close the dialog
      }
    } catch (e) {
      print('Error deleting task: $e');
      if (context.mounted) {
        _showErrorMessage(context, 'Erro de comunicação: $e');
      }
      return false;
    }
  }
  
  // Check if user can edit/delete tasks
  bool canEditTasks() {
    return FFAppState().isManager;
  }
  
  // Show error message
  void _showErrorMessage(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(fontSize: 14.0),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4), // More time for longer messages
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );
    }
  }
  
  // Validate form and show specific missing fields
  String? getValidationError() {
    List<String> missingFields = [];
    
    if (mensagemController?.text.isEmpty ?? true) {
      missingFields.add("Descrição da task");
    }
    
    if (selectedTipoDestino?.isEmpty ?? true) {
      missingFields.add("Tipo de destino");
    }
    
    // Check destination based on type
    if (selectedTipoDestino == 'Coordenada') {
      if (destinoXController?.text.isEmpty ?? true) {
        missingFields.add("Coordenada X");
      }
      if (destinoYController?.text.isEmpty ?? true) {
        missingFields.add("Coordenada Y");
      }
    } else {
      if (selectedDestino?.isEmpty ?? true) {
        missingFields.add("Destino");
      }
    }
    
    if (selectedTipo?.isEmpty ?? true) {
      missingFields.add("Tipo da task");
    }
    
    if (selectedStatus?.isEmpty ?? true) {
      missingFields.add("Status da task");
    }
    
    if (selectedBeacons.isEmpty) {
      missingFields.add("Pelo menos um beacon");
    }
    
    if (missingFields.isEmpty) {
      return null; // No errors
    }
    
    return "Campos obrigatórios não preenchidos:\n• ${missingFields.join('\n• ')}";
  }

  // Validate form
  bool validateForm() {
    return getValidationError() == null;
  }
}
