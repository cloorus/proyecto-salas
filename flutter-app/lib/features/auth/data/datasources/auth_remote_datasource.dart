/// Data Source para operaciones remotas de autenticación
abstract class AuthRemoteDataSource {
  /// Login con API (retorna UserModel y token)
  Future<Map<String, dynamic>> login(String email, String password);
  
  /// Registro de nuevo usuario (retorna UserModel y token)
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
    String? country,
    String? language,
  });
  
  /// Enviar código de restablecimiento
  Future<void> sendPasswordResetCode(String email);
  
  /// Restablecer contraseña
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
  
  /// Logout en API
  Future<void> logout();
}

/// Implementación MOCK del data source remoto
class AuthRemoteDataSourceMock implements AuthRemoteDataSource {
  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Simular delay de red
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock: validar credenciales
    if (email == 'carlos@bgnius.com' && password == 'Admin123!') {
      return {
        'user': {
          'id': '1',
          'name': 'Carlos Mena',
          'email': email,
          'phone': '+503 1234-5678',
          'photoUrl': null,
          'role': 'admin',
          'createdAt': DateTime.now().toIso8601String(),
        },
        'token': 'mock_jwt_token_12345',
      };
    } else {
      throw Exception('Credenciales inválidas');
    }
  }
  
  
  @override
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
    String? country,
    String? language,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock: simular registro exitoso
    return {
      'user': {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': name,
        'email': email,
        'phone': phone,
        'photoUrl': null,
        'role': 'user',
        'createdAt': DateTime.now().toIso8601String(),
      },
      'token': 'mock_jwt_token_new_user',
    };
  }
  
  @override
  Future<void> sendPasswordResetCode(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock: solo simula el envío del código
    // En producción aquí se llamaría al endpoint real
  }
  
  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    // Mock: simula validación de código y cambio de contraseña
    // En producción validaría el código con el backend
  }
  
  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock: no hace nada
  }
}
