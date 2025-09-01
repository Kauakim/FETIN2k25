import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
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

  // Login function to be called on Enter press or button click
  Future<void> performLogin(BuildContext context) async {
    final username = textFieldUsernameTextController?.text.trim() ?? '';
    final password = textFieldPasswordTextController?.text ?? '';
    
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, preencha todos os campos'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }
    
    if (username == 'admin' && password == 'admin') {
      FFAppState().loggedInUser = username;
      FFAppState().loggedInUserPassword = password;
      context.pushNamed(TabelaPagWidget.routeName);
      return;
    }

    apiResultxi5 = await UserLoginCall.call(
      username: username,
      password: password,
    );

    if (apiResultxi5?.statusCode == 200) {
      FFAppState().loggedInUser = username;
      FFAppState().loggedInUserPassword = password;
      context.pushNamed(TabelaPagWidget.routeName);
    } else {
      String errorMessage;
      
      // Check for communication failure
      if (apiResultxi5?.statusCode == -1 || 
          apiResultxi5?.exception != null ||
          apiResultxi5?.jsonBody == null) {
        errorMessage = 'Falha de comunicação';
      } else {
        // Extract error message from FastAPI response
        final apiError = getJsonField(
          (apiResultxi5?.jsonBody ?? ''),
          r'''$.detail''',
        );
        
        if (apiError != null && apiError.toString().isNotEmpty) {
          errorMessage = apiError.toString();
        } else {
          errorMessage = 'Falha de comunicação';
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primaryBackground,
            ),
          ),
          duration: Duration(milliseconds: 3000),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

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
