import '/flutter_flow/flutter_flow_util.dart';
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
  
  // User data
  String nomeUsuario = "João Silva";
  String senhaUsuario = "123456789";
  String fotoPerfilUrl = "https://via.placeholder.com/150";

  @override
  void initState(BuildContext context) {}

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
