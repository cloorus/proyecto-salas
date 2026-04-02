import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../../shared/widgets/custom_text_field.dart';
import '../../../../../../shared/widgets/expandable_section.dart';

class PhysicalInfoSection extends StatelessWidget {
  final TextEditingController hardwareVersionController;
  final TextEditingController firmwareVersionController;
  final bool isLoading;

  const PhysicalInfoSection({
    super.key,
    required this.hardwareVersionController,
    required this.firmwareVersionController,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableSection(
      title: AppLocalizations.of(context)!.deviceFormSectionPhysical,
      icon: Icons.hardware_outlined,
      children: [
        const SizedBox(height: 8),
        CustomTextField(
          hintText: 'Ej: 2.1.0',
          labelText: 'Versión de Hardware',
          controller: hardwareVersionController,
          prefixIcon: Icons.memory,
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          hintText: 'Ej: 3.2.1',
          labelText: 'Versión de Firmware',
          controller: firmwareVersionController,
          prefixIcon: Icons.developer_board,
          enabled: !isLoading,
        ),
      ],
    );
  }
}
