import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:async';
import 'tabela_pag_widget.dart' show TabelaPagWidget;
import 'package:flutter/material.dart';

class TabelaPagModel extends FlutterFlowModel<TabelaPagWidget> {
  ///  Local state fields for this page.

  List<dynamic> allBeacons = [];
  void addToAllBeacons(dynamic item) => allBeacons.add(item);
  void removeFromAllBeacons(dynamic item) => allBeacons.remove(item);
  void removeAtIndexFromAllBeacons(int index) => allBeacons.removeAt(index);
  void insertAtIndexInAllBeacons(int index, dynamic item) =>
    allBeacons.insert(index, item);
  void updateAllBeaconsAtIndex(int index, Function(dynamic) updateFn) =>
    allBeacons[index] = updateFn(allBeacons[index]);

  List<dynamic> filteredBeacons = [];
  void addToFilteredBeacons(dynamic item) => filteredBeacons.add(item);
  void removeFromFilteredBeacons(dynamic item) => filteredBeacons.remove(item);
  void removeAtIndexFromFilteredBeacons(int index) =>
    filteredBeacons.removeAt(index);
  void insertAtIndexInFilteredBeacons(int index, dynamic item) =>
    filteredBeacons.insert(index, item);
  void updateFilteredBeaconsAtIndex(int index, Function(dynamic) updateFn) =>
    filteredBeacons[index] = updateFn(filteredBeacons[index]);

  String searchText = '.';

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  Completer<ApiCallResponse>? apiRequestCompleter;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }

  /// Additional helper methods.
  Future waitForApiRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = apiRequestCompleter?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
