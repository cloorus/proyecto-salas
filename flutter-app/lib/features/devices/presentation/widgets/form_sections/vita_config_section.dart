import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../shared/widgets/expandable_section.dart';

class VitaConfigSection extends StatelessWidget {
  final String? selectedPowerType;
  final List<String> powerTypeOptions;
  final Function(String?) onPowerTypeChanged;
  
  final String? selectedMotorType;
  final List<String> motorTypeOptions;
  final Function(String?) onMotorTypeChanged;
  
  final bool openingPhotocell;
  final Function(bool) onOpeningPhotocellChanged;
  
  final bool closingPhotocell;
  final Function(bool) onClosingPhotocellChanged;
  
  final bool isLoading;

  const VitaConfigSection({
    super.key,
    required this.selectedPowerType,
    required this.powerTypeOptions,
    required this.onPowerTypeChanged,
    required this.selectedMotorType,
    required this.motorTypeOptions,
    required this.onMotorTypeChanged,
    required this.openingPhotocell,
    required this.onOpeningPhotocellChanged,
    required this.closingPhotocell,
    required this.onClosingPhotocellChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableSection(
      title: AppLocalizations.of(context)!.deviceFormSectionVita,
      icon: Icons.tune_outlined,
      children: [
         const SizedBox(height: 8),
         _buildDropdownField(
           context: context,
           label: AppLocalizations.of(context)!.powerTypeLabel, 
           hint: AppLocalizations.of(context)!.selectPlaceholder, 
           value: selectedPowerType, 
           items: powerTypeOptions, 
           onChanged: !isLoading ? onPowerTypeChanged : null,
          ),
         const SizedBox(height: 16),
         _buildDropdownField(
           context: context,
           label: AppLocalizations.of(context)!.motorTypeLabel, 
           hint: AppLocalizations.of(context)!.selectPlaceholder, 
           value: selectedMotorType, 
           items: motorTypeOptions, 
           onChanged: !isLoading ? onMotorTypeChanged : null,
          ),
         const SizedBox(height: 24),
         _buildSwitchTile(AppLocalizations.of(context)!.openingPhotocellLabel, openingPhotocell, onOpeningPhotocellChanged),
         _buildSwitchTile(AppLocalizations.of(context)!.closingPhotocellLabel, closingPhotocell, onClosingPhotocellChanged),
      ]
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
  
  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.bodyMedium),
          Switch(
            value: value,
            onChanged: !isLoading ? onChanged : null,
            activeColor: AppColors.primaryPurple,
          ),
        ],
      ),
    );
  }
}
