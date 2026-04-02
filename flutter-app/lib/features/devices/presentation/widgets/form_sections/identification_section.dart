import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../shared/widgets/custom_text_field.dart';

class IdentificationSection extends StatelessWidget {
  final TextEditingController serialController;
  final TextEditingController macController;
  final String? selectedModel;
  final List<String> modelOptions;
  final Function(String?) onModelChanged;
  final bool isReadOnly;
  final bool isLoading;

  const IdentificationSection({
    super.key,
    required this.serialController,
    required this.macController,
    required this.selectedModel,
    required this.modelOptions,
    required this.onModelChanged,
    this.isLoading = false,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle(context, AppLocalizations.of(context)!.deviceFormSectionId),
        const SizedBox(height: 16),

        CustomTextField(
          key: const Key('input_serial'),
          labelText: AppLocalizations.of(context)!.deviceFormSerialLabel,
          hintText: AppLocalizations.of(context)!.serialNumberPlaceholder,
          controller: serialController,
          validator: (val) => isReadOnly ? null : Validators.serialNumber(val, context),
          enabled: !isLoading && !isReadOnly,
          prefixIcon: Icons.qr_code,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          key: const Key('input_mac'),
          labelText: AppLocalizations.of(context)!.deviceFormMacLabel,
          hintText: '00:00:00:00:00:00',
          controller: macController,
          validator: (val) => isReadOnly ? null : Validators.required(val, context), // TODO: Add specific MAC validator
          enabled: !isLoading && !isReadOnly,
          prefixIcon: Icons.wifi,
        ),
        const SizedBox(height: 16),

        _buildDropdownField(
          context: context,
          label: AppLocalizations.of(context)!.deviceFormModelLabel,
          hint: AppLocalizations.of(context)!.deviceFormModelPlaceholder,
          value: selectedModel,
          items: modelOptions,
          onChanged: !isLoading && !isReadOnly ? onModelChanged : null,
          icon: Icons.devices,
          enabled: !isLoading && !isReadOnly,
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
