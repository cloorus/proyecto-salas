import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../devices/domain/entities/device.dart';

class AddDeviceSection extends StatefulWidget {
  final List<Device> availableDevices;
  final String? selectedDeviceId;
  final ValueChanged<String?> onDeviceChanged;
  final VoidCallback onAdd;

  const AddDeviceSection({
    super.key,
    required this.availableDevices,
    required this.selectedDeviceId,
    required this.onDeviceChanged,
    required this.onAdd,
  });

  @override
  State<AddDeviceSection> createState() => _AddDeviceSectionState();
}

class _AddDeviceSectionState extends State<AddDeviceSection> {
  final TextEditingController _menuController = TextEditingController();

  @override
  void didUpdateWidget(AddDeviceSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDeviceId == null && _menuController.text.isNotEmpty) {
      _menuController.clear();
    }
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(),
        const SizedBox(height: 16),

        // Compact Search & Selection with DropdownMenu
        LayoutBuilder(
          builder: (context, constraints) {
            return DropdownMenu<String>(
              controller: _menuController,
              width: constraints.maxWidth,
              enableFilter: true,
              requestFocusOnTap: true,
              leadingIcon: const Icon(Icons.search, color: AppColors.titleBlue),
              label: Text(
                l10n.groupsSubtitleAddMore,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(
                      color: AppColors.primaryPurple, width: 2),
                ),
              ),
              menuHeight: 300,
              dropdownMenuEntries: widget.availableDevices.map((device) {
                return DropdownMenuEntry<String>(
                  value: device.id,
                  label: device.name,
                  style: MenuItemButton.styleFrom(
                    foregroundColor: Colors.black87,
                  ),
                );
              }).toList(),
              onSelected: (String? deviceId) {
                widget.onDeviceChanged(deviceId);
              },
            );
          },
        ),

        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: widget.availableDevices.isEmpty ||
                    widget.selectedDeviceId == null
                ? null
                : widget.onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              l10n.groupsButtonAdd,
              style: AppTextStyles.buttonText,
            ),
          ),
        ),
      ],
    );
  }
}
