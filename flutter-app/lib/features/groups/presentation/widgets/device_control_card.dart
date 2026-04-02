import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/control_buttons_panel.dart';
import '../../../devices/domain/entities/device.dart';

class DeviceControlCard extends StatelessWidget {
  final Device device;
  final String? statusText;
  final Function(DeviceCommand) onCommand;
  final VoidCallback onMoreDetails;

  const DeviceControlCard({
    super.key,
    required this.device,
    this.statusText,
    required this.onCommand,
    required this.onMoreDetails,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50], // Could look for AppColors equivalent
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.groupsControlPrefix(device.name),
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ControlButtonsPanel(
            onCommandPressed: onCommand,
            isExecuting: false,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Text(
              statusText ?? l10n.groupsStatusReady,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onMoreDetails,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryPurple,
                side: const BorderSide(color: AppColors.primaryPurple),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(l10n.groupsButtonMoreDetails),
            ),
          ),
        ],
      ),
    );
  }
}
