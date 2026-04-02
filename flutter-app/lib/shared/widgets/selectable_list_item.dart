import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_text_styles.dart';

/// Item de lista seleccionable con estilo BGnius
///
/// Características:
/// - Fondo gris claro (inactivo) o morado claro (activo)
/// - Borde púrpura grueso cuando está seleccionado
/// - Texto principal
/// - Widget opcional a la derecha (trailing) o marcador de selección automático
class SelectableListItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap; // New callback
  final Widget? trailing;
  final Widget? leading; // New leading widget
  final bool showSelectionMarker;
  final double fontSize;

  const SelectableListItem({
    super.key,
    required this.title,
    required this.isSelected,
    this.onTap,
    this.onDoubleTap,
    this.trailing,
    this.leading,
    this.showSelectionMarker = true,
    this.fontSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD6CEDE) // Fondo morado claro seleccionado
              : const Color(0xFFE4E5EA), // Fondo gris normal
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: const Color(0xFF662d91), width: 1.5)
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            // Widget personalizado al final (trailing)
            if (trailing != null)
              trailing!
            // O marcador de selección por defecto (Logo)
            else if (showSelectionMarker && isSelected)
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.transparent, // Fondo transparente
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SvgPicture.asset(
                  'assets/images/IconoLogo_transparente.svg',
                  fit: BoxFit.contain,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
