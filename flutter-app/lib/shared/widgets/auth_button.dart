import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

/// Botón personalizado para pantallas de autenticación
/// 
/// Características:
/// - Estilo neumórfico con sombras
/// - Bordes redondeados (50px)
/// - Soporte para estado de loading
/// - Variantes: filled (default) y outline
/// 
/// Ejemplo:
/// ```dart
/// AuthButton(
///   text: 'Ingresar',
///   onPressed: _handleLogin,
///   isLoading: _isLoading,
/// )
/// 
/// AuthButton(
///   text: 'Crear Usuario',
///   onPressed: _handleRegister,
///   isOutline: true,
/// )
/// ```
class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutline;
  final double? width;

  const AuthButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutline = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonFontSize = screenWidth > 700 ? 18.0 : 16.0;
    final defaultWidth = screenWidth > 700 
        ? (screenWidth > 700 ? 850.0 : screenWidth * 0.90) * 0.5
        : screenWidth * 0.90 * 0.5;

    return Container(
      width: width ?? defaultWidth,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: isOutline ? AppColors.inputBorder : Colors.white,
          width: isOutline ? 0.5 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: isOutline ? 10 : 12,
            spreadRadius: 0,
            offset: Offset(0, isOutline ? 6 : 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textSecondary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColors.textSecondary,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: GoogleFonts.montserrat(
                  fontSize: buttonFontSize,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
      ),
    );
  }
}
