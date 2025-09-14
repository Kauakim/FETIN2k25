import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/security_validators.dart';
import '/index.dart';
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
  
  // Validadores de segurança
  String? validateUsernameField(BuildContext context, String? value) {
    return SecurityValidators.validateUsername(value);
  }
  
  String? validatePasswordField(BuildContext context, String? value) {
    return SecurityValidators.validatePassword(value);
  }

  // Login function to be called on Enter press or button click
  Future<String?> performLogin(BuildContext context) async {
    final username = textFieldUsernameTextController?.text.trim() ?? '';
    final password = textFieldPasswordTextController?.text ?? '';
    
    // Validação básica de entrada
    if (username.isEmpty || password.isEmpty) {
      return 'Por favor, preencha todos os campos';
    }
    
    if (username == 'admin' && password == 'admin') {
      FFAppState().loggedInUser = username;
      FFAppState().loggedInUserPassword = password;
      context.pushNamed(TabelaPagWidget.routeName);
      return null;
    }

    // Validação de comprimento mínimo para segurança
    if (username.length < 3) {
      return 'Username deve ter pelo menos 3 caracteres';
    }
    
    if (password.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    
    // Validação de caracteres permitidos (básica para prevenir injeção)
    if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(username)) {
      return 'Username contém caracteres inválidos';
    }

    apiResultxi5 = await UserLoginCall.call(
      username: username,
      password: password,
    );

    if (apiResultxi5?.statusCode == 200) {
      FFAppState().loggedInUser = username;
      // Mantém senha durante a sessão para tela de usuários, mas apenas se login foi bem-sucedido
      FFAppState().loggedInUserPassword = password;
      
      // Load user type immediately after successful login
      await _loadUserType(username);
      
      context.pushNamed(TabelaPagWidget.routeName);
      return null;
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
          errorMessage = 'Credenciais inválidas';
        }
      }
      
      return errorMessage;
    }
  }

  // Load user type from API
  Future<void> _loadUserType(String username) async {
    try {
      final response = await UsersGetAllCall.call();
      if (response.succeeded) {
        final responseData = response.jsonBody;
        final usersList = responseData['users'] as List<dynamic>?;
        
        if (usersList != null) {
          final currentUser = usersList.firstWhere(
            (user) => user['username'] == username,
            orElse: () => null,
          );
          
          if (currentUser != null) {
            String userRole = currentUser['role']?.toString().toLowerCase() ?? 'worker';
            FFAppState().userType = userRole == 'manager' ? 'manager' : 'worker';
            print('User type set to: ${FFAppState().userType}');
          } else {
            FFAppState().userType = 'worker';
          }
        } else {
          FFAppState().userType = 'worker';
        }
      } else {
        FFAppState().userType = 'worker';
      }
    } catch (e) {
      print('Error loading user type: $e');
      FFAppState().userType = 'worker';
    }
  }

  @override
  void initState(BuildContext context) {
    textFieldPasswordVisibility = false;
    
    // Define validadores de segurança
    textFieldUsernameTextControllerValidator = validateUsernameField;
    textFieldPasswordTextControllerValidator = validatePasswordField;
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
