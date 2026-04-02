import 'package:flutter/material.dart';

/// Paleta de colores de BGnius VITA
/// Basado en el Design System del documento de especificación y mockups
class AppColors {
  AppColors._();

  // ============ COLORES PRIMARIOS ============
  
  /// Púrpura Principal - Botones principales, encabezados, elementos activos
  static const Color primaryPurple = Color(0xFF7B2CBF);
  
  /// Púrpura de Pestañas - Color exacto del mockup para tabs (#673AB7)
  static const Color tabPurple = Color(0xFF673AB7);
  
  /// Azul Secundario - Botones secundarios, enlaces, títulos
  static const Color secondaryBlue = Color(0xFF0072BC);
  
  /// Azul Oscuro - Títulos de pantallas (#303F9F del mockup)
  static const Color titleBlue = Color(0xFF303F9F);

  // ============ COLORES DE ESTADO ============
  
  /// Verde Éxito - Confirmaciones, estado "conectado"
  static const Color success = Color(0xFF4CAF50);
  
  /// Rojo Error - Errores, estado "desconectado", acciones peligrosas
  static const Color error = Color(0xFFE53935);
  
  /// Naranja Advertencia - Alertas, estado "mantenimiento"
  static const Color warning = Color(0xFFFF9800);
  
  /// Azul Info - Mensajes informativos
  static const Color info = Color(0xFF2196F3);

  // ============ COLORES NEUTROS ============
  
  /// Fondo de pantallas
  static const Color background = Color(0xFFF5F5F5);
  
  /// Fondo de cards y campos
  static const Color surface = Color(0xFFFFFFFF);
  
  /// Fondo de cards secundarias (gris muy claro)
  static const Color surfaceSecondary = Color(0xFFFAFAFA);
  
  /// Texto principal
  static const Color textPrimary = Color(0xFF212121);
  
  /// Texto secundario
  static const Color textSecondary = Color(0xFF757575);
  
  /// Texto deshabilitado
  static const Color textDisabled = Color(0xFF9E9E9E);
  
  /// Bordes de inputs
  static const Color inputBorder = Color(0xFFDDDDDD);
  
  /// Divisores
  static const Color divider = Color(0xFFE0E0E0);

  // ============ COLORES DE DISPOSITIVO ============
  
  /// Header de dispositivo (gris claro)
  static const Color deviceHeader = Color(0xFFEEEEEE);
  
  /// Panel de control (gris muy claro)
  static const Color controlPanel = Color(0xFFF8F8F8);
  
  /// Estado Online (verde)
  static const Color statusOnline = Color(0xFF4CAF50);
  
  /// Estado Offline (gris)
  static const Color statusOffline = Color(0xFF9E9E9E);

  // ============ BADGES Y NOTIFICACIONES ============
  
  /// Badge de conteo (púrpura)
  static const Color badge = Color(0xFF7B2CBF);
  
  /// Badge de nuevo (rojo)
  static const Color badgeNew = Color(0xFFE53935);

  // ============ SOMBRAS ============
  
  /// Sombra de cards
  static Color cardShadow = Colors.black.withValues(alpha: 0.08);
  
  /// Sombra de botón
  static Color buttonShadow = const Color(0xFF7B2CBF).withValues(alpha: 0.3);
  
  /// Sombra de modal
  static Color modalShadow = Colors.black.withValues(alpha: 0.15);

  // ============ GRADIENTES ============
  
  /// Gradiente del header (púrpura a magenta)
  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF7B2CBF), Color(0xFFAB47BC)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  /// Gradiente del bottom navigation
  static const LinearGradient bottomNavGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFFAFAFA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ============ COLORES DE BOTONES DE CONTROL ============
  
  /// Botón Abrir
  static const Color openButton = Color(0xFF4CAF50);
  
  /// Botón Cerrar
  static const Color closeButton = Color(0xFFFF5722);
  
  /// Botón Pausa
  static const Color pauseButton = Color(0xFF9E9E9E);
  
  /// Botón Peatonal
  static const Color pedestrianButton = Color(0xFF03A9F4);
  
  // ============ COLORES INTERACTIVOS ============
  
  /// Hover effect (overlay)
  static Color hoverOverlay = Colors.black.withValues(alpha: 0.04);
  
  /// Pressed effect (overlay)
  static Color pressedOverlay = Colors.black.withValues(alpha: 0.08);
  
  /// Ripple effect
  static Color ripple = const Color(0xFF7B2CBF).withValues(alpha: 0.12);
}

