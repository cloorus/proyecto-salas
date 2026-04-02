import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/device_info_provider.dart';
import '../widgets/info_card.dart';

class DeviceInfoScreen extends ConsumerWidget {
  final String deviceId;

  const DeviceInfoScreen({
    super.key,
    required this.deviceId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final deviceInfoAsync = ref.watch(deviceInfoProvider(deviceId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            PageHeader(
              title: l10n.deviceInfoTitle, // Keeps "Información del Dispositivo"
              titleFontSize: 22,
              showBackButton: true,
            ),
            Expanded(
              child: deviceInfoAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
                data: (device) => _buildContent(context, device),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, dynamic device) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGeneralSection(context, device),
          const SizedBox(height: 24),
          _buildIdentitySection(context, device),
          const SizedBox(height: 24),
          _buildPhysicalSection(context, device),
          const SizedBox(height: 24),
          _buildOperationalSection(context, device),
          const SizedBox(height: 24),
          _buildMaintenanceSection(context, device),
          const SizedBox(height: 24),
          _buildVitaConfigSection(context, device),
          const SizedBox(height: 24),
          _buildOtherSection(context, device),
        ],
      ),
    );
  }

  Widget _buildGeneralSection(BuildContext context, dynamic device) {
    final l10n = AppLocalizations.of(context);
    return _buildSection(
      context,
      title: l10n.deviceInfoSectionGeneral,
      children: [
        InfoCard(label: l10n.deviceInfoModelLabel, value: device.model),
        InfoCard(label: l10n.deviceInfoNameLabel, value: device.name),
        InfoCard(label: l10n.deviceInfoDescriptionLabel, value: device.description),
        InfoCard(label: l10n.deviceInfoGroupLabel, value: device.groupName),
        InfoCard(
          label: l10n.deviceInfoFavoriteLabel,
          value: device.isFavorite ? l10n.deviceInfoYes : l10n.deviceInfoNo,
        ),
        InfoCard(
          label: l10n.deviceInfoPhotoLabel,
          value: device.hasCustomPhoto
              ? l10n.deviceInfoCustomPhoto
              : l10n.deviceInfoDefaultPhoto,
        ),
      ],
    );
  }

  Widget _buildIdentitySection(BuildContext context, dynamic device) {
    final l10n = AppLocalizations.of(context);
    return _buildSection(
      context,
      title: l10n.deviceInfoSectionIdentity,
      children: [
        InfoCard(label: l10n.deviceInfoSerialLabel, value: device.serialNumber),
        InfoCard(label: l10n.deviceInfoMacLabel, value: device.macAddress),
        InfoCard(label: l10n.deviceInfoStatusLabel, value: device.status),
      ],
    );
  }

  Widget _buildPhysicalSection(BuildContext context, dynamic device) {
    final l10n = AppLocalizations.of(context);
    return _buildSection(
      context,
      title: l10n.deviceInfoSectionPhysical,
      children: [
        InfoCard(label: l10n.deviceInfoHwVersionLabel, value: device.hardwareVersion),
        InfoCard(label: l10n.deviceInfoFwVersionLabel, value: device.firmwareVersion),
        InfoCard(label: l10n.deviceInfoVersionLabel, value: device.fullVersion),
      ],
    );
  }

  Widget _buildOperationalSection(BuildContext context, dynamic device) {
    final l10n = AppLocalizations.of(context);
    return _buildSection(
      context,
      title: l10n.deviceInfoSectionOperational,
      children: [
        InfoCard(
          label: l10n.deviceInfoAutoCloseLabel,
          value: l10n.deviceInfoSecondsValue(device.autoCloseSeconds),
        ),
        InfoCard(
          label: l10n.deviceInfoMaxOpenTimeLabel,
          value: l10n.deviceInfoSecondsValue(device.maxOpenTimeSeconds),
        ),
        InfoCard(
          label: l10n.deviceInfoPedestrianTimeoutLabel,
          value: l10n.deviceInfoSecondsValue(device.pedestrianTimeoutSeconds),
        ),
        InfoCard(
          label: l10n.deviceInfoEmergencyModeLabel,
          value: device.isEmergencyMode ? l10n.deviceInfoYes : l10n.deviceInfoNo,
        ),
        InfoCard(
          label: l10n.deviceInfoAutoLampLabel,
          value: device.isAutoLampOn ? l10n.deviceInfoYes : l10n.deviceInfoNo,
        ),
        InfoCard(
          label: l10n.deviceInfoMaintenanceModeLabel,
          value: device.isMaintenanceMode ? l10n.deviceInfoYes : l10n.deviceInfoNo,
        ),
        InfoCard(
          label: l10n.deviceInfoLockedLabel,
          value: device.isLocked ? l10n.deviceInfoYes : l10n.deviceInfoNo,
        ),
      ],
    );
  }

  Widget _buildMaintenanceSection(BuildContext context, dynamic device) {
    final l10n = AppLocalizations.of(context);
    return _buildSection(
      context,
      title: l10n.deviceInfoSectionMaintenance,
      children: [
        InfoCard(
          label: l10n.deviceInfoInstallationDateLabel,
          value: device.installationDate != null 
            ? DateFormat('dd/MM/yyyy').format(device.installationDate!) 
            : 'N/A',
        ),
        InfoCard(
          label: l10n.deviceInfoWarrantyDateLabel,
          value: device.warrantyExpirationDate != null 
            ? DateFormat('dd/MM/yyyy').format(device.warrantyExpirationDate!) 
            : 'N/A',
        ),
        InfoCard(
          label: l10n.deviceInfoScheduledMaintLabel,
          value: device.scheduledMaintenanceDate != null 
            ? DateFormat('dd/MM/yyyy').format(device.scheduledMaintenanceDate!) 
            : 'N/A',
        ),
        InfoCard(
          label: l10n.deviceInfoActivationDateLabel,
          value: DateFormat('dd/MM/yyyy').format(device.activationDate),
        ),
        InfoCard(
          label: l10n.deviceInfoTotalCyclesLabel,
          value: '${device.totalCycles}',
        ),
        InfoCard(
          label: l10n.deviceInfoMaintNotesLabel,
          value: device.maintenanceNotes,
        ),
      ],
    );
  }

  Widget _buildVitaConfigSection(BuildContext context, dynamic device) {
    final l10n = AppLocalizations.of(context);
    return _buildSection(
      context,
      title: l10n.deviceInfoSectionConfig,
      children: [
        InfoCard(label: l10n.deviceInfoPowerTypeLabel, value: device.powerType),
        InfoCard(label: l10n.deviceInfoMotorTypeLabel, value: device.motorType),
        InfoCard(
          label: l10n.deviceInfoOpeningPhotocellLabel, 
          value: device.hasOpeningPhotocell ? l10n.deviceInfoYes : l10n.deviceInfoNo
        ),
        InfoCard(
          label: l10n.deviceInfoClosingPhotocellLabel, 
          value: device.hasClosingPhotocell ? l10n.deviceInfoYes : l10n.deviceInfoNo
        ),
      ],
    );
  }

  Widget _buildOtherSection(BuildContext context, dynamic device) {
    final l10n = AppLocalizations.of(context);
    return _buildSection(
      context,
      title: l10n.deviceInfoSectionOther,
      children: [
        InfoCard(
          label: l10n.deviceInfoTechnicianLabel,
          value: device.technicalContact ?? 'N/A',
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 4),
          child: Text(
            title,
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: 18,
              color: AppColors.primaryPurple,
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive Grid: 1 column on small screens, 2 on larger
            final crossAxisCount = constraints.maxWidth > 500 ? 2 : 1;
            if (crossAxisCount == 1) {
              return Column(
                children: children
                    .map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: c,
                        ))
                    .toList(),
              );
            } else {
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: children.map((c) {
                  return SizedBox(
                    width: (constraints.maxWidth - 12) / 2,
                    child: c,
                  );
                }).toList(),
              );
            }
          },
        ),
      ],
    );
  }
}
