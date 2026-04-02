import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Widget para mostrar sección de información con icono, título y contenido
/// 
/// Este componente reutilizable muestra información estructurada con:
/// - Un icono a la izquierda
/// - Un título y contenido organizados verticalmente
/// - Soporte para color personalizado del contenido
/// 
/// Ejemplo de uso:
/// ```dart
/// InfoSection(
///   icon: Icons.location_on_outlined,
///   title: 'Ubicación',
///   content: 'Sala principal',
/// )
/// ```
class InfoSection extends StatelessWidget {
  /// Icono a mostrar a la izquierda
  final IconData icon;
  
  /// Título de la sección (texto secundario)
  final String title;
  
  /// Contenido principal a mostrar
  final String content;
  
  /// Color opcional para el contenido
  final Color? contentColor;

  const InfoSection({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: contentColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
