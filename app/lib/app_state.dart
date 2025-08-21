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
}
