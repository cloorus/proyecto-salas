import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../shared/widgets/custom_text_field.dart';

class BasicInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final String? selectedLocation;
  final List<String> locationOptions;
  final Function(String?) onLocationChanged;
  
  final String? selectedType;
  final List<String> typeOptions;
  final Function(String?) onTypeChanged;
  
  final String? selectedStatus;
  final List<String> statusOptions;
  final Function(String?) onStatusChanged;
  
  final DateTime? activationDate; // Added
  final Function(DateTime?) onActivationDateChanged; // Added
  final bool isFavorite; // Added
  final Function(bool) onIsFavoriteChanged; // Added

  final bool isLoading;

  const BasicInfoSection({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.selectedLocation,
    required this.locationOptions,
    required this.onLocationChanged,
    required this.selectedType,
    required this.typeOptions,
    required this.onTypeChanged,
    required this.selectedStatus,
    required this.statusOptions,
    required this.onStatusChanged,
    required this.activationDate,
    required this.onActivationDateChanged,
    required this.isFavorite,
    required this.onIsFavoriteChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle(context, AppLocalizations.of(context)!.deviceFormSectionBasic),
        const SizedBox(height: 16),
        
        CustomTextField(
          key: const Key('input_name'),
          hintText: AppLocalizations.of(context)!.deviceFormNamePlaceholder,
          labelText: AppLocalizations.of(context)!.deviceFormNameLabel,
          controller: nameController,
          validator: (val) => Validators.deviceName(val, context),
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),
        
        // Activation Date
        _buildDatePicker(
            context,
            AppLocalizations.of(context)!.activationDateLabel,
            activationDate,
            onActivationDateChanged,
        ),
        const SizedBox(height: 16),

        _buildDropdownField(
          context: context,
          label: AppLocalizations.of(context)!.deviceFormLocationLabel,
          hint: AppLocalizations.of(context)!.deviceFormLocationPlaceholder,
          value: selectedLocation,
          items: locationOptions,
          onChanged: onLocationChanged,
          enabled: !isLoading,
          icon: Icons.location_on_outlined,
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                context: context,
                label: AppLocalizations.of(context)!.deviceFormTypeLabel,
                hint: AppLocalizations.of(context)!.deviceFormTypePlaceholder,
                value: selectedType,
                items: typeOptions,
                onChanged: onTypeChanged,
                enabled: !isLoading,
                icon: Icons.category_outlined,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdownField(
                context: context,
                label: AppLocalizations.of(context)!.deviceFormStatusLabel,
                hint: AppLocalizations.of(context)!.deviceFormStatusPlaceholder,
                value: selectedStatus,
                items: statusOptions,
                onChanged: onStatusChanged,
                enabled: !isLoading,
                icon: Icons.info_outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Favorite Switch
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppColors.inputBorder),
            ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.favoriteDeviceLabel, style: AppTextStyles.inputLabel),
              Switch(
                value: isFavorite,
                onChanged: isLoading ? null : onIsFavoriteChanged,
                activeColor: AppColors.primaryPurple,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        CustomTextField(
          key: const Key('input_description'),
          hintText: AppLocalizations.of(context)!.deviceFormDescriptionPlaceholder,
          labelText: AppLocalizations.of(context)!.deviceFormDescriptionLabel,
          controller: descriptionController,
          maxLines: 3,
          enabled: !isLoading,
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, String label, DateTime? date, Function(DateTime?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.inputLabel),
        const SizedBox(height: 8),
        InkWell(
          onTap: isLoading ? null : () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) onChanged(picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary, size: 22),
                const SizedBox(width: 12),
                Text(
                  date != null ? "${date.day}/${date.month}/${date.year}" : AppLocalizations.of(context)!.selectDatePlaceholder,
                  style: date != null ? AppTextStyles.inputText : AppTextStyles.inputHint,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: AppTextStyles.cardTitle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryPurple,
      ),
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
    IconData? icon,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: AppTextStyles.inputLabel),
          const SizedBox(height: 8),
        ],
        Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppColors.textSecondary, size: 22),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: value,
                      hint: Text(hint, style: AppTextStyles.inputHint),
                      isExpanded: true,
                      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: AppTextStyles.inputText))).toList(),
                      onChanged: enabled ? onChanged : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
