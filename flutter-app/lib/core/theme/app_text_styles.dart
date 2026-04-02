import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Estilos de texto de BGnius VITA
class AppTextStyles {
  AppTextStyles._();

  // ============ TÍTULOS ============
  
  // ============ TÍTULOS ============
  
  /// Título de pantalla (ej: "Bienvenido", "Crear Usuario")
  static TextStyle get screenTitle => GoogleFonts.montserrat(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.titleBlue,
  );
  
  /// Subtítulo de sección
  static TextStyle get sectionTitle => GoogleFonts.montserrat(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.titleBlue,
  );
  
  /// Título de AppBar
  static TextStyle get appBarTitle => GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.titleBlue,
  );
  
  /// Título mediano
  static TextStyle get titleMedium => GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  /// Título de card/item
  static TextStyle get cardTitle => GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  
  /// Encabezado pequeño
  static TextStyle get headlineSmall => GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ============ CUERPO ============
  
  /// Texto normal
  static TextStyle get bodyLarge => GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  
  /// Texto mediano
  static TextStyle get bodyMedium => GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  
  /// Texto pequeño
  static TextStyle get bodySmall => GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ============ BOTONES ============
  
  /// Texto de botón principal
  static TextStyle get buttonText => GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600, // Ajustado a w600 para coincidir con diseño
    color: Colors.white,
  );
  
  /// Texto de botón pequeño
  static TextStyle get buttonTextSmall => GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // ============ INPUTS ============
  
  /// Texto dentro de campos
  static TextStyle get inputText => GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  
  /// Hint/placeholder de campos
  static TextStyle get inputHint => GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  
  /// Label de campos
  static TextStyle get inputLabel => GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  
  /// Mensaje de error
  static TextStyle get inputError => GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
  );

  // ============ ENLACES ============
  
  /// Enlace (ej: "Olvidé mi contraseña")
  static TextStyle get link => GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
    decoration: TextDecoration.none,
  );
  
  /// Enlace secundario
  static TextStyle get linkSecondary => GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryBlue,
    decoration: TextDecoration.none,
  );

  // ============ DISPOSITIVOS ============
  
  /// Nombre de dispositivo en lista
  static TextStyle get deviceName => GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  
  /// Info de dispositivo (modelo, serie)
  static TextStyle get deviceInfo => GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  
  /// Estado del dispositivo
  static TextStyle get deviceStatus => GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  // ============ ETIQUETAS ============
  
  /// Etiqueta de control (Abrir, Cerrar, etc.)
  static TextStyle get controlLabel => GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w600, // Ajustado a w600
    color: AppColors.textSecondary,
  );
}
