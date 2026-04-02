import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class InfoCard extends StatelessWidget {
  final String? label;
  final String value;

  const InfoCard({
    super.key,
    this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
        border: Border.all(color: const Color(0xFFF5F5F5)),
      ),
      child: Row(
        mainAxisAlignment: label != null
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          if (label != null)
            Flexible(
              flex: 3,
              child: Text(
                label!,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            flex: 2,
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: label != null ? FontWeight.w400 : FontWeight.w500,
                color: label != null
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
              ),
              textAlign: label != null ? TextAlign.right : TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
