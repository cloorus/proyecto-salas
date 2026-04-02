/// Endpoints de la API de BGnius VITA
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - API real de Vita
  static const String baseUrl = 'https://api-bgnius.webcomcr.com/api/v1';
  
  // Auth Endpoints
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String refreshToken = '$baseUrl/auth/refresh';
  static const String userProfile = '$baseUrl/users/me';
  
  // Device Endpoints
  static const String devices = '$baseUrl/devices';
  static String deviceById(String id) => '$baseUrl/devices/$id';
  static String deviceControl(String id) => '$baseUrl/devices/$id/control';
  static String deviceParams(String id) => '$baseUrl/devices/$id/params';
  static String deviceEvents(String id) => '$baseUrl/devices/$id/events';
  static String deviceUsers(String id) => '$baseUrl/devices/$id/users';
  
  // User Endpoints
  static const String users = '$baseUrl/users';
  static String userById(String id) => '$baseUrl/users/$id';
  static String userDevices(String id) => '$baseUrl/users/$id/devices';
  static String userRoles(String userId, String deviceId) => 
      '$baseUrl/users/$userId/devices/$deviceId/roles';
  
  // Group Endpoints
  static const String groups = '$baseUrl/groups';
  static String groupById(String id) => '$baseUrl/groups/$id';
  static String groupDevices(String id) => '$baseUrl/groups/$id/devices';
  
  // Support Endpoints
  static const String support = '$baseUrl/support/contact';
  static String deviceSupport(String id) => '$baseUrl/devices/$id/support';
}
