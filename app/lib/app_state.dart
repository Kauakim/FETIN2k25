import 'package:flutter/material.dart';
import 'dart:async';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  // Timer para sessão
  Timer? _sessionTimer;
  static const Duration _sessionTimeout = Duration(minutes: 30); // 30 minutos de inatividade
  DateTime? _lastActivity;

  /// JSON bruto dos beacons
  dynamic _beaconsRawJson;
  dynamic get beaconsRawJson => _beaconsRawJson;
  set beaconsRawJson(dynamic value) {
    _beaconsRawJson = value;
    _updateActivity();
  }

  /// Usuário logado
  String _loggedInUser = '';
  String get loggedInUser => _loggedInUser;
  set loggedInUser(String value) {
    _loggedInUser = value;
    _updateActivity();
    notifyListeners();
  }

  /// Senha do usuário logado - apenas acessível durante sessão ativa
  String _loggedInUserPassword = '';
  String get loggedInUserPassword => _loggedInUserPassword;
  set loggedInUserPassword(String value) {
    _loggedInUserPassword = value;
    notifyListeners();
  }
  
  /// Acesso seguro à senha - apenas se sessão for válida
  /// Retorna senha apenas se usuário autenticado e sessão ativa
  String getSecurePassword() {
    if (!isSessionValid) {
      return ''; // Retorna vazio se sessão inválida
    }
    return _loggedInUserPassword;
  }

  /// Dados do usuário logado
  Map<String, dynamic> _userInfo = {};
  Map<String, dynamic> get userInfo => _userInfo;
  set userInfo(Map<String, dynamic> value) {
    _userInfo = value;
    _updateActivity();
    notifyListeners();
  }

  /// Tipo do usuário logado (manager ou worker)
  String _userType = 'worker';
  String get userType => _userType;
  set userType(String value) {
    _userType = value;
    notifyListeners();
  }

  /// Verifica se o usuário é manager
  bool get isManager => _userType.toLowerCase() == 'manager';
  
  /// Verifica se o usuário é worker
  bool get isWorker => _userType.toLowerCase() == 'worker';
  
  /// Verifica se há usuário logado
  bool get isLoggedIn => _loggedInUser.isNotEmpty;
  
  /// Atualiza atividade do usuário (para controle de sessão)
  void _updateActivity() {
    _lastActivity = DateTime.now();
    _startSessionTimer();
  }
  
  /// Inicia timer de sessão
  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(_sessionTimeout, () {
      logout();
    });
  }
  
  /// Logout do usuário (limpa dados sensíveis)
  void logout() {
    _loggedInUser = '';
    _loggedInUserPassword = ''; // Limpa senha
    _userInfo.clear();
    _userType = 'worker';
    _beaconsRawJson = null;
    _sessionTimer?.cancel();
    _lastActivity = null;
    notifyListeners();
  }
  
  /// Verifica se a sessão está válida
  bool get isSessionValid {
    if (!isLoggedIn || _lastActivity == null) return false;
    return DateTime.now().difference(_lastActivity!) < _sessionTimeout;
  }
}
