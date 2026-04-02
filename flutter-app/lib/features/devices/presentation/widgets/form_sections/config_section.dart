import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../shared/widgets/custom_text_field.dart';
import '../../../../../../shared/widgets/expandable_section.dart';

class ConfigSection extends StatelessWidget {
  final TextEditingController autoCloseController;
  final TextEditingController maxOpenTimeController;
  final TextEditingController pedestrianTimeoutController;
  
  final bool emergencyMode;
  final Function(bool) onEmergencyModeChanged;
  
  final bool autoLampOn;
  final Function(bool) onAutoLampOnChanged;
  
  final bool maintenanceMode;
  final Function(bool) onMaintenanceModeChanged;
  
  final bool locked;
  final Function(bool) onLockedChanged;
  
  final bool isLoading;

  const ConfigSection({
    super.key,
    required this.autoCloseController,
    required this.maxOpenTimeController,
    required this.pedestrianTimeoutController,
    required this.emergencyMode,
    required this.onEmergencyModeChanged,
    required this.autoLampOn,
    required this.onAutoLampOnChanged,
    required this.maintenanceMode,
    required this.onMaintenanceModeChanged,
    required this.locked,
    required this.onLockedChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableSection(
      title: AppLocalizations.of(context)!.deviceFormSectionConfig,
      icon: Icons.settings_outlined,
      children: [
        const SizedBox(height: 8),
        CustomTextField(
          hintText: 'Segundos',
          labelText: 'Auto-cierre',
          prefixIcon: Icons.timer_outlined,
          controller: autoCloseController,
          keyboardType: TextInputType.number,
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          hintText: 'Segundos',
          labelText: 'Tiempo máximo abierto',
          prefixIcon: Icons.lock_open_outlined,
          controller: maxOpenTimeController,
          keyboardType: TextInputType.number,
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          hintText: 'Segundos',
          labelText: 'Timeout peatonal',
          prefixIcon: Icons.directions_walk_outlined,
          controller: pedestrianTimeoutController,
          keyboardType: TextInputType.number,
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),
        _buildSwitchTile('Modo Emergencia', emergencyMode, onEmergencyModeChanged),
        _buildSwitchTile('Lámpara Auto-On', autoLampOn, onAutoLampOnChanged),
        _buildSwitchTile('Modo Mantenimiento', maintenanceMode, onMaintenanceModeChanged),
        _buildSwitchTile('Bloqueado', locked, onLockedChanged),
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
