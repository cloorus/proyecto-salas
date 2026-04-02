import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Tipo de Snackbar
enum SnackbarType { success, error, warning, info }

/// Helper para mostrar Snackbars consistentes
class SnackbarHelper {
  SnackbarHelper._();

  /// Muestra un Snackbar exitoso
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, SnackbarType.success);
  }

  /// Muestra un Snackbar de error
  static void showError(BuildContext context, String message) {
    _show(context, message, SnackbarType.error);
  }

  /// Muestra un Snackbar de advertencia
  static void showWarning(BuildContext context, String message) {
    _show(context, message, SnackbarType.warning);
  }

  /// Muestra un Snackbar informativo
  static void showInfo(BuildContext context, String message) {
    _show(context, message, SnackbarType.info);
  }

  /// Muestra un Snackbar genérico
  static void _show(BuildContext context, String message, SnackbarType type) {
    final color = _getColor(type);
    final icon = _getIcon(type);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static Color _getColor(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return AppColors.success;
      case SnackbarType.error:
        return AppColors.error;
      case SnackbarType.warning:
        return AppColors.warning;
      case SnackbarType.info:
        return AppColors.info;
    }
  }

  static IconData _getIcon(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return Icons.check_circle_outline;
      case SnackbarType.error:
        return Icons.error_outline;
      case SnackbarType.warning:
        return Icons.warning_amber_outlined;
      case SnackbarType.info:
        return Icons.info_outline;
    }
  }
}
