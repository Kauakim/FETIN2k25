import 'package:flutter/material.dart';

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

  /// JSON bruto dos beacons
  dynamic _beaconsRawJson;
  dynamic get beaconsRawJson => _beaconsRawJson;
  set beaconsRawJson(dynamic value) {
    _beaconsRawJson = value;
  }

  /// Usuário logado
  String _loggedInUser = '';
  String get loggedInUser => _loggedInUser;
  set loggedInUser(String value) {
    _loggedInUser = value;
    notifyListeners();
  }

  /// Senha do usuário logado
  String _loggedInUserPassword = '';
  String get loggedInUserPassword => _loggedInUserPassword;
  set loggedInUserPassword(String value) {
    _loggedInUserPassword = value;
    notifyListeners();
  }

  /// Dados do usuário logado
  Map<String, dynamic> _userInfo = {};
  Map<String, dynamic> get userInfo => _userInfo;
  set userInfo(Map<String, dynamic> value) {
    _userInfo = value;
    notifyListeners();
  }
}
