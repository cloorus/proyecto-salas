import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

/// Panel de información gris para mostrar datos de dispositivo o usuario
class InfoPanel extends StatelessWidget {
  final List<InfoPanelItem> items;
  final EdgeInsets padding;
  final Color backgroundColor;

  const InfoPanel({
    super.key,
    required this.items,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor = const Color(0xFFF5F5F5),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          int index = entry.key;
          InfoPanelItem item = entry.value;
          bool isLast = index == items.length - 1;

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.label,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    item.value,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (!isLast) ...[
                const SizedBox(height: 12),
                Divider(
                  color: Colors.grey.shade400,
                  height: 1,
                ),
                const SizedBox(height: 12),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }
}

/// Modelo para un item en el InfoPanel
class InfoPanelItem {
  final String label;
  final String value;

  InfoPanelItem({
    required this.label,
    required this.value,
  });
}
