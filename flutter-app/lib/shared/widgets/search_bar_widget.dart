import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Barra de búsqueda reutilizable
class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilter;
  final TextEditingController? controller;
  final bool showFilterButton;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Buscar...',
    this.onChanged,
    this.onFilter,
    this.controller,
    this.showFilterButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: hintText ?? AppLocalizations.of(context)!.searchPlaceholder,
          hintStyle: AppTextStyles.inputHint,
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: 22,
          ),
          suffixIcon: showFilterButton && onFilter != null
              ? IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: AppColors.primaryPurple,
                    size: 22,
                  ),
                  onPressed: onFilter,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: AppColors.primaryPurple,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          filled: true,
          fillColor: AppColors.surface,
        ),
      ),
    );
  }
}
