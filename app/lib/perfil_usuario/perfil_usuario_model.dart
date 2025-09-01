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
  String get nomeUsuario => _userInfo?['nome'] ?? FFAppState().loggedInUser;
  String get senhaUsuario => FFAppState().loggedInUserPassword.isNotEmpty 
    ? FFAppState().loggedInUserPassword 
    : (_actualPassword.isNotEmpty ? _actualPassword : 'ERROR');
  String get emailUsuario => _userInfo?['email'] ?? 'usuario@exemplo.com';
  String get cargoUsuario => _userInfo?['cargo'] ?? 'Funcionário';
  String get departamentoUsuario => _userInfo?['departamento'] ?? 'Produção';
  bool get isLoading => _isLoading;

  // Load user information from API
  Future<void> loadUserInfo() async {
    try {
      _isLoading = true;
      _onStateChanged?.call();
      
      // Get user info from API based on logged in user
      final response = await UserGetInfoCall.call(
        username: FFAppState().loggedInUser,
      );
      
      if (response.succeeded) {
        _userInfo = response.jsonBody;
        _actualPassword = _userInfo?['password'] ?? FFAppState().loggedInUserPassword;
      } else {
        // Fallback data if API fails - use the password from login
        _userInfo = {
          'nome': FFAppState().loggedInUser,
          'email': '${FFAppState().loggedInUser.toLowerCase()}@empresa.com',
          'cargo': 'Operador',
          'departamento': 'Produção',
        };
        _actualPassword = FFAppState().loggedInUserPassword;
      }
    } catch (e) {
      print('Error loading user info: $e');
      // Fallback data - use the password from login
      _userInfo = {
        'nome': FFAppState().loggedInUser,
        'email': '${FFAppState().loggedInUser.toLowerCase()}@empresa.com',
        'cargo': 'Operador',
        'departamento': 'Produção',
      };
      _actualPassword = FFAppState().loggedInUserPassword;
    } finally {
      _isLoading = false;
      _onStateChanged?.call();
    }
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
}
