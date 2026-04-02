import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class GroupSelectorItem extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const GroupSelectorItem({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.tabPurple
                  : const Color(0xFFF0F0F0), // Mantengo gris claro neutro
              borderRadius: BorderRadius.circular(20),
              border: isSelected
                  ? Border.all(color: AppColors.tabPurple)
                  : Border.all(color: Colors.transparent),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.tabPurple.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            child: Text(
              name,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? Colors.white : Colors.black54,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
