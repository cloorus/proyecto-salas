import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

/// Checkbox con label personalizado
/// 
/// Características:
/// - Checkbox small (20x20)
/// - Label personalizable
/// - Estados: enabled/disabled
/// - Estilo consistente con Design System
/// 
/// Ejemplo:
/// ```dart
/// LabeledCheckbox(
///   label: 'Recuérdame',
///   value: _rememberMe,
///   onChanged: (value) => setState(() => _rememberMe = value ?? false),
/// )
/// ```
class LabeledCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final bool enabled;

  const LabeledCheckbox({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final labelFontSize = screenWidth > 700 ? 16.0 : 14.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeColor: AppColors.primaryPurple,
            side: BorderSide(
              color: AppColors.inputBorder,
              width: 1.5,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: labelFontSize * 0.9,
            fontWeight: FontWeight.w400,
            color: enabled ? AppColors.textSecondary : AppColors.textDisabled,
          ),
        ),
      ],
    );
  }
}
