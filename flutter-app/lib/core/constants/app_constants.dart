/// Constantes de la aplicación BGnius VITA
class AppConstants {
  AppConstants._();

  // Información de la App
  static const String appName = 'BGnius VITA';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Control de Accesos IoT';

  // Configuración de UI
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double smallPadding = 8.0;
  
  static const double buttonHeight = 52.0;
  static const double inputHeight = 56.0;
  
  static const double borderRadiusButton = 30.0;
  static const double borderRadiusInput = 25.0;
  static const double borderRadiusCard = 16.0;
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  
  // Límites
  static const int maxDevicesPerUser = 50;
  static const int maxUsersPerDevice = 100;
  
  // Storage Keys
  static const String storageKeyToken = 'auth_token';
  static const String storageKeyUser = 'current_user';
  static const String storageKeyDevices = 'cached_devices';
  static const String storageKeyTheme = 'theme_mode';
}
