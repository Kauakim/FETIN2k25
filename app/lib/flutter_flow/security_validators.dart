/// Utilitários de validação para segurança do app
class SecurityValidators {
  
  /// Valida username - permite apenas caracteres seguros
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username é obrigatório';
    }
    
    final trimmed = value.trim();
    
    if (trimmed.length < 3) {
      return 'Username deve ter pelo menos 3 caracteres';
    }
    
    if (trimmed.length > 50) {
      return 'Username muito longo (máximo 50 caracteres)';
    }

    // Permite apenas letras, números e espaços
    if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(trimmed)) {
      return 'Username contém caracteres inválidos';
    }
    
    return null;
  }
  
  /// Valida senha - requisitos básicos de segurança
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    
    if (value.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    
    if (value.length > 100) {
      return 'Senha muito longa (máximo 100 caracteres)';
    }
    
    return null;
  }
  
  /// Valida texto genérico - previne injeção básica
  static String? validateSafeText(String? value, {String? fieldName, int? maxLength}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Campo'} é obrigatório';
    }
    
    final trimmed = value.trim();
    final max = maxLength ?? 200;
    
    if (trimmed.length > max) {
      return '${fieldName ?? 'Campo'} muito longo (máximo $max caracteres)';
    }
    
    // Previne caracteres potencialmente perigosos
    if (RegExp(r'''[<>"';\\]''').hasMatch(trimmed)) {
      return '${fieldName ?? 'Campo'} contém caracteres não permitidos';
    }
    
    return null;
  }
  
  /// Valida ID de beacon
  static String? validateBeaconId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'ID do beacon é obrigatório';
    }
    
    final trimmed = value.trim();
    
    if (trimmed.length > 50) {
      return 'ID do beacon muito longo (máximo 50 caracteres)';
    }
    
    // Permite letras, números, espaços, hífens e underscores
    if (!RegExp(r'^[a-zA-Z0-9 _-]+$').hasMatch(trimmed)) {
      return 'ID do beacon contém caracteres inválidos';
    }
    
    return null;
  }
  
  /// Valida coordenadas numéricas
  static String? validateCoordinate(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Coordenadas podem ser opcionais
    }
    
    final trimmed = value.trim();
    
    // Verifica se é um número válido
    final number = double.tryParse(trimmed);
    if (number == null) {
      return '${fieldName ?? 'Coordenada'} deve ser um número válido';
    }
    
    return null;
  }
  
  /// Sanitiza entrada de texto removendo caracteres perigosos
  static String sanitizeInput(String input) {
    return input
        .trim()
        .replaceAll(RegExp(r'''[<>"';\\]'''), '') // Remove caracteres perigosos
        .replaceAll(RegExp(r'\s+'), ' '); // Normaliza espaços
  }
}