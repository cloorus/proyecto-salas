import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

/// Sección expandible con encabezado y contenido
class SettingsSection extends StatefulWidget {
  final String title;
  final IconData? icon;
  final List<Widget> children;
  final bool initiallyExpanded;
  final Color? backgroundColor;

  const SettingsSection({
    super.key,
    required this.title,
    this.icon,
    required this.children,
    this.initiallyExpanded = false,
    this.backgroundColor,
  });

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            color: widget.backgroundColor ?? Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: AppColors.primaryPurple,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      widget.title,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.titleBlue,
                      ),
                    ),
                  ],
                ),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.primaryPurple,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Container(
            color: widget.backgroundColor ?? Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                const Divider(height: 1),
                const SizedBox(height: 12),
                ...widget.children,
              ],
            ),
          ),
      ],
    );
  }
}
