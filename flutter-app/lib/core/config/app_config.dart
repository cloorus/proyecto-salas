/// Configuración global de la aplicación
class AppConfig {
  AppConfig._();

  /// Toggle para usar API real vs datos mock
  /// Cambiar a `false` para usar datos mock durante desarrollo
  static const bool useRealApi = true;

  /// URL base de la API de Vita
  static const String apiBaseUrl = 'http://157.245.1.231:8000/api/v1';

  /// Configuraciones de timeout
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  /// Credenciales de prueba
  static const String testEmail = 'admin@bgnius.com';
  static const String testPassword = 'Test1234!';

  /// Debug mode
  static const bool enableApiLogs = true;
  
  /// Configuraciones de token
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String rememberMeKey = 'remember_me';
  static const String userDataKey = 'user_data';
}