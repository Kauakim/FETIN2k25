import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'inicial_widget.dart' show InicialWidget;
import 'package:flutter/material.dart';

class InicialModel extends FlutterFlowModel<InicialWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
    tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
    tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for textField_Username widget.
  FocusNode? textFieldUsernameFocusNode;
  TextEditingController? textFieldUsernameTextController;
  String? Function(BuildContext, String?)?
    textFieldUsernameTextControllerValidator;
  // State field(s) for textField_Password widget.
  FocusNode? textFieldPasswordFocusNode;
  TextEditingController? textFieldPasswordTextController;
  late bool textFieldPasswordVisibility;
  String? Function(BuildContext, String?)?
    textFieldPasswordTextControllerValidator;
  // Stores action output result for [Backend Call - API (UserLogin)] action in Button widget.
  ApiCallResponse? apiResultxi5;

  @override
  void initState(BuildContext context) {
    textFieldPasswordVisibility = false;
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    textFieldUsernameFocusNode?.dispose();
    textFieldUsernameTextController?.dispose();

    textFieldPasswordFocusNode?.dispose();
    textFieldPasswordTextController?.dispose();
  }
}
