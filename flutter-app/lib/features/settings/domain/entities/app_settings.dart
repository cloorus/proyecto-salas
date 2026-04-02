import 'package:equatable/equatable.dart';

/// Entidad de Configuraciones de la Aplicación
class AppSettings extends Equatable {
  final bool darkMode;
  final double fontSize; // 0.8 = Pequeño, 1.0 = Normal, 1.2 = Grande
  final bool highContrast;
  final bool reducedMotion;
  final bool biometricsEnabled;
  final Environment environment;
  final String? serverUrl;

  const AppSettings({
    this.darkMode = false,
    this.fontSize = 1.0,
    this.highContrast = false,
    this.reducedMotion = false,
    this.biometricsEnabled = false,
    this.environment = Environment.production,
    this.serverUrl,
  });

  /// Crea una copia de las configuraciones con los campos especificados actualizados
  AppSettings copyWith({
    bool? darkMode,
    double? fontSize,
    bool? highContrast,
    bool? reducedMotion,
    bool? biometricsEnabled,
    Environment? environment,
    String? serverUrl,
  }) {
    return AppSettings(
      darkMode: darkMode ?? this.darkMode,
      fontSize: fontSize ?? this.fontSize,
      highContrast: highContrast ?? this.highContrast,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      environment: environment ?? this.environment,
      serverUrl: serverUrl ?? this.serverUrl,
    );
  }

  @override
  List<Object?> get props => [
        darkMode,
        fontSize,
        highContrast,
        reducedMotion,
        biometricsEnabled,
        environment,
        serverUrl,
      ];
}

/// Entornos de la aplicación
enum Environment {
  development,  // Desarrollo
  staging,      // Staging/Pruebas
  production,   // Producción
}

extension EnvironmentExtension on Environment {
  String get displayName {
    switch (this) {
      case Environment.development:
        return 'Desarrollo';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Producción';
    }
  }

  String get defaultServerUrl {
    switch (this) {
      case Environment.development:
        return 'https://dev-api.bgnius.com';
      case Environment.staging:
        return 'https://staging-api.bgnius.com';
      case Environment.production:
        return 'https://api.bgnius.com';
    }
  }
}

/// Tamaños de fuente disponibles
enum FontSize {
  small(0.8, 'Pequeño'),
  normal(1.0, 'Normal'),
  large(1.2, 'Grande');

  const FontSize(this.value, this.displayName);
  
  final double value;
  final String displayName;
}