import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../shared/widgets/custom_text_field.dart';
import '../../../../../../shared/widgets/expandable_section.dart';

class MaintenanceSection extends StatelessWidget {
  final DateTime? installationDate;
  final Function(DateTime) onInstallationDateChanged;
  
  final DateTime? warrantyDate;
  final Function(DateTime) onWarrantyDateChanged;
  
  final DateTime? scheduledMaintenanceDate;
  final Function(DateTime) onScheduledMaintenanceDateChanged;
  
  final TextEditingController maintenanceNotesController;
  final TextEditingController technicalContactController;
  final bool isLoading;

  const MaintenanceSection({
    super.key,
    required this.installationDate,
    required this.onInstallationDateChanged,
    required this.warrantyDate,
    required this.onWarrantyDateChanged,
    required this.scheduledMaintenanceDate,
    required this.onScheduledMaintenanceDateChanged,
    required this.maintenanceNotesController,
    required this.technicalContactController,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableSection(
      title: AppLocalizations.of(context)!.deviceFormSectionMaintenance,
      icon: Icons.build_outlined,
      children: [
        const SizedBox(height: 8),
        _buildDateButton(context, AppLocalizations.of(context)!.installationDateLabel, installationDate, onInstallationDateChanged),
        const SizedBox(height: 16),
        _buildDateButton(context, AppLocalizations.of(context)!.warrantyExpirationLabel, warrantyDate, onWarrantyDateChanged),
        const SizedBox(height: 16),
        _buildDateButton(context, AppLocalizations.of(context)!.scheduledMaintenanceLabel, scheduledMaintenanceDate, onScheduledMaintenanceDateChanged),
        const SizedBox(height: 16),
        CustomTextField(
          hintText: AppLocalizations.of(context)!.technicianNamePlaceholder,
          labelText: AppLocalizations.of(context)!.technicalContactLabel,
          prefixIcon: Icons.person_outline,
          controller: technicalContactController,
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          hintText: AppLocalizations.of(context)!.additionalNotesPlaceholder,
          labelText: AppLocalizations.of(context)!.maintenanceNotesLabel,
          prefixIcon: Icons.note_outlined,
          controller: maintenanceNotesController,
          maxLines: 3,
          enabled: !isLoading,
        ),
      ],
    );
  }

  Widget _buildDateButton(BuildContext context, String label, DateTime? selectedDate, Function(DateTime) onSelect) {
    return OutlinedButton(
      onPressed: !isLoading ? () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2050),
        );
        if (date != null) {
          onSelect(date);
        }
      } : null,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        side: BorderSide(color: AppColors.inputBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 12),
          Text(
            selectedDate != null ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}' : label,
            style: AppTextStyles.inputHint,
          ),
        ],
      ),
    );
  }
}
