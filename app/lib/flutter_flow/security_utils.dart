import 'package:flutter/material.dart';
import '/app_state.dart';
import '/index.dart';

/// Utilitários de segurança para gerenciamento de sessão
class SecurityUtils {
  
  /// Verifica se a sessão do usuário ainda é válida
  static bool isSessionValid() {
    return FFAppState().isSessionValid;
  }
  
  /// Força logout e redireciona para tela de login
  static void forceLogout(BuildContext context) {
    FFAppState().logout();
    Navigator.of(context).pushNamedAndRemoveUntil(
      InicialWidget.routePath, 
      (route) => false
    );
  }
  
  /// Middleware para verificar autenticação em páginas protegidas
  static Future<bool> checkAuthMiddleware(BuildContext context) async {
    if (!FFAppState().isLoggedIn || !isSessionValid()) {
      forceLogout(context);
      return false;
    }
    
    // Atualiza atividade do usuário
    FFAppState().update(() {});
    return true;
  }
  
  /// Limpa dados sensíveis da memória (para uso em dispose)
  static void clearSensitiveData() {
    // Força garbage collection de dados sensíveis
    FFAppState().loggedInUserPassword = '';
  }
}