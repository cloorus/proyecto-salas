import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Toggle widget for device ON/OFF controls (Lámpara, Relé).
///
/// Displays a card with icon, label, and two toggle buttons (ON/OFF).
/// Follows BGnius VITA design system with purple color scheme.
///
/// Example:
/// ```dart
/// DeviceControlToggle(
///   icon: Icons.wb_incandescent_rounded,
///   label: 'Lámpara',
///   isOn: device.lampEnabled ?? false,
///   isEnabled: !isLoading && device.isConnected,
///   onToggle: (isOn) => sendCommand(isOn ? 'LAMP_ON' : 'LAMP_OFF'),
/// )
/// ```
class DeviceControlToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isOn;
  final bool isEnabled;
  final void Function(bool isOn) onToggle;

  const DeviceControlToggle({
    Key? key,
    required this.icon,
    required this.label,
    required this.isOn,
    required this.isEnabled,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOn && isEnabled
              ? AppTheme.primaryPurple.withOpacity(0.3)
              : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Icon(
            icon,
            size: 32,
            color: isOn && isEnabled
                ? AppTheme.primaryPurple
                : Colors.grey.shade600,
          ),
          const SizedBox(height: 8),

          // Label
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isEnabled ? AppTheme.textDark : Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 12),

          // Toggle Buttons (ON/OFF)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ON Button
              Expanded(
                child: _buildToggleButton(
                  label: 'ON',
                  isSelected: isOn,
                  onPressed: isEnabled ? () => onToggle(true) : null,
                ),
              ),
              const SizedBox(width: 8),
              // OFF Button
              Expanded(
                child: _buildToggleButton(
                  label: 'OFF',
                  isSelected: !isOn,
                  onPressed: isEnabled ? () => onToggle(false) : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? AppTheme.primaryPurple
            : Colors.white,
        foregroundColor: isSelected
            ? Colors.white
            : AppTheme.primaryPurple,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected
                ? AppTheme.primaryPurple
                : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        elevation: isSelected ? 2 : 0,
        disabledBackgroundColor: Colors.grey.shade200,
        disabledForegroundColor: Colors.grey.shade400,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
