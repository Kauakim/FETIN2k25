import '/flutter_flow/flutter_flow_util.dart';
import '/backend/api_requests/api_calls.dart';
import 'perfil_usuario_widget.dart' show PerfilUsuarioWidget;
import 'package:flutter/material.dart';
import 'dart:async';

class PerfilUsuarioModel extends FlutterFlowModel<PerfilUsuarioWidget> {
  // State field(s) for password visibility
  bool senhaVisibility = false;
  
  // State field(s) for tracking toggle
  bool isTrackingEnabled = false;
  
  // Timer for tracking function
  Timer? _trackingTimer;
  
  // Callback for state updates
  VoidCallback? _onStateChanged;
  
  // User data will be loaded from API
  Map<String, dynamic>? _userInfo;
  bool _isLoading = true;
  String _actualPassword = '';

  // Getters for user data
  String get nomeUsuario => _userInfo?['username'] ?? FFAppState().loggedInUser;
  String get senhaUsuario => FFAppState().loggedInUserPassword.isNotEmpty 
    ? FFAppState().loggedInUserPassword 
    : (_actualPassword.isNotEmpty ? _actualPassword : 'ERROR');
  String get emailUsuario => _userInfo?['email'] ?? '';
  String get roleUsuario => _userInfo?['role'] ?? '';
  bool get isLoading => _isLoading;
  
  // User type getters
  bool get isManager => FFAppState().isManager;
  bool get isWorker => FFAppState().isWorker;
  String get userType => FFAppState().userType;

  // Load user information from API
  Future<void> loadUserInfo() async {
    try {
      _isLoading = true;
      _onStateChanged?.call();
      
      // Get all users from API and find the logged in user
      final response = await UsersGetAllCall.call();
      print('All users response: ${response.jsonBody}');

      if (response.succeeded) {
        final responseData = response.jsonBody;
        final usersList = responseData['users'] as List<dynamic>?;
        
        if (usersList != null) {
          // Find the current logged in user in the list
          final currentUser = usersList.firstWhere(
            (user) => user['username'] == FFAppState().loggedInUser,
            orElse: () => null,
          );
          
          if (currentUser != null) {
            _userInfo = currentUser;
            _actualPassword = FFAppState().loggedInUserPassword;
            
            // Set user type based on role from API
            String userRole = _userInfo?['role']?.toString().toLowerCase() ?? 'worker';
            FFAppState().userType = userRole == 'manager' ? 'manager' : 'worker';
            
            print('Found user: $_userInfo');
          } else {
            print('User ${FFAppState().loggedInUser} not found in users list');
            _setFallbackUserInfo();
          }
        } else {
          print('No users list found in response');
          _setFallbackUserInfo();
        }
      } else {
        print('Failed to get users from API');
        _setFallbackUserInfo();
      }
    } catch (e) {
      print('Error loading user info: $e');
      _setFallbackUserInfo();
    } finally {
      _isLoading = false;
      _onStateChanged?.call();
    }
  }
  
  void _setFallbackUserInfo() {
    // Fallback data - use the password from login
    _userInfo = {
      'username': FFAppState().loggedInUser,
      'email': '',
      'role': 'worker',
    };
    _actualPassword = FFAppState().loggedInUserPassword;
    FFAppState().userType = 'worker';
  }
  
  void setStateCallback(VoidCallback callback) {
    _onStateChanged = callback;
  }

  @override
  void initState(BuildContext context) {
    // Load user info when model is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadUserInfo();
    });
  }

  @override
  void dispose() {
    // Cancel timer when disposing
    _trackingTimer?.cancel();
    
    // Dispose controllers
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    roleController.dispose();
    
    // Dispose focus nodes
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    emailFocusNode.dispose();
    roleFocusNode.dispose();
  }
  
  void toggleSenhaVisibility() {
    senhaVisibility = !senhaVisibility;
  }
  
  void toggleTracking() {
    isTrackingEnabled = !isTrackingEnabled;
    
    if (isTrackingEnabled) {
      startTracking();
    } else {
      stopTracking();
    }
  }
  
  void startTracking() {
    // Cancel any existing timer
    _trackingTimer?.cancel();
    
    // Start new timer that repeats every 5 seconds
    _trackingTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      executeTrackingFunction();
    });
    
    // Execute immediately when starting
    executeTrackingFunction();
  }
  
  void stopTracking() {
    _trackingTimer?.cancel();
    _trackingTimer = null;
  }
  
  void executeTrackingFunction() {
    // TODO: Implement tracking functionality here
    // This function will be called every 5 seconds when tracking is enabled
    print("Executing tracking function - ${DateTime.now()}");
    
    // Placeholder for future tracking implementation
    // Example: Send location data, update status, etc.
  }

  // User management functionality
  List<Map<String, dynamic>> _allUsers = [];
  bool _isLoadingUsers = false;
  bool _showCreateForm = false;
  bool _showEditForm = false;
  Map<String, dynamic>? _editingUser;

  // Controllers for user form
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  // Focus nodes
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode roleFocusNode = FocusNode();

  // Getters
  List<Map<String, dynamic>> get allUsers => _allUsers;
  bool get isLoadingUsers => _isLoadingUsers;
  bool get showCreateForm => _showCreateForm;
  bool get showEditForm => _showEditForm;
  Map<String, dynamic>? get editingUser => _editingUser;

  // Load all users
  Future<void> loadAllUsers() async {
    try {
      _isLoadingUsers = true;
      _onStateChanged?.call();

      final response = await UsersGetAllCall.call();
      print('UsersGetAllCall response: ${response.jsonBody}');
      
      if (response.succeeded) {
        final responseData = response.jsonBody;
        _allUsers = List<Map<String, dynamic>>.from(responseData['users'] ?? []);
      } else {
        _allUsers = [];
      }
    } catch (e) {
      print('Error loading users: $e');
      _allUsers = [];
    } finally {
      _isLoadingUsers = false;
      _onStateChanged?.call();
    }
  }

  // Toggle create form
  void toggleCreateForm() {
    _showCreateForm = !_showCreateForm;
    if (_showCreateForm) {
      _showEditForm = false;
      _editingUser = null;
      clearForm();
    }
    _onStateChanged?.call();
  }

  // Show edit form
  void showEditUserForm(Map<String, dynamic> user) {
    _editingUser = user;
    _showEditForm = true;
    _showCreateForm = false;
    
    // Populate form with user data
    usernameController.text = user['username'] ?? '';
    emailController.text = user['email'] ?? '';
    roleController.text = user['role'] ?? '';
    passwordController.text = ''; // Don't show password
    
    _onStateChanged?.call();
  }

  // Hide forms
  void hideForms() {
    _showCreateForm = false;
    _showEditForm = false;
    _editingUser = null;
    clearForm();
    _onStateChanged?.call();
  }

  // Clear form
  void clearForm() {
    usernameController.clear();
    passwordController.clear();
    emailController.clear();
    roleController.clear();
  }

  // Create user
  Future<bool> createUser() async {
    try {
      final response = await UserSigninCall.call(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
        email: emailController.text.trim(),
        role: roleController.text.trim(),
      );

      if (response.succeeded) {
        hideForms();
        await loadAllUsers(); // Reload users list
        return true;
      }
      return false;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  // Update user
  Future<bool> updateUser() async {
    if (_editingUser == null) return false;
    
    try {
      final response = await UserUpdateCall.call(
        oldUsername: _editingUser!['username'],
        newUsername: usernameController.text.trim(),
        password: passwordController.text.trim(),
        email: emailController.text.trim(),
        role: roleController.text.trim(),
      );

      if (response.succeeded) {
        hideForms();
        await loadAllUsers(); // Reload users list
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  // Delete user
  Future<bool> deleteUser(String username) async {
    try {
      final response = await UserDeleteCall.call(username: username);

      if (response.succeeded) {
        await loadAllUsers(); // Reload users list
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }
}
