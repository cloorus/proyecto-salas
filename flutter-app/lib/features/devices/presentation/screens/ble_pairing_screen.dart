import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/snackbar_helper.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../domain/repositories/provisioning_repository.dart';
import '../providers/provisioning_provider.dart';

/// Pantalla de Emparejamiento BLE para dispositivos VITA
/// Flujo de 5 pasos: Escanear → Conectar → Info → Configurar → Éxito
class BlePairingScreen extends ConsumerStatefulWidget {
  const BlePairingScreen({super.key});

  @override
  ConsumerState<BlePairingScreen> createState() => _BlePairingScreenState();
}

class _BlePairingScreenState extends ConsumerState<BlePairingScreen> {
  // Controladores para el formulario de configuración
  final _deviceNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedDeviceType = 'gate';

  @override
  void dispose() {
    _deviceNameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provisioningState = ref.watch(bleProvisioningProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            PageHeader(
              title: AppLocalizations.of(context)!.blePairingTitle,
              showBackButton: true,
              onBack: () async {
                // Desconectar antes de salir
                await ref.read(bleProvisioningProvider.notifier).disconnect();
                if (context.mounted) context.pop();
              },
            ),
            
            // Progress Indicator
            Container(
              padding: const EdgeInsets.all(16),
              child: LinearProgressIndicator(
                value: (provisioningState.currentStep + 1) / 5.0,
                backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation(AppColors.primaryPurple),
              ),
            ),

            // Main Content - Stepper
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: AppColors.primaryPurple,
                  ),
                ),
                child: Stepper(
                  currentStep: provisioningState.currentStep,
                  onStepTapped: (step) {
                    // Solo permitir navegar a pasos anteriores ya completados
                    if (step < provisioningState.currentStep) {
                      ref.read(bleProvisioningProvider.notifier).goToStep(step);
                    }
                  },
                  controlsBuilder: (context, details) => const SizedBox.shrink(),
                  steps: [
                    _buildScanStep(context, provisioningState),
                    _buildDeviceListStep(context, provisioningState),
                    _buildConnectionStep(context, provisioningState),
                    _buildConfigurationStep(context, provisioningState),
                    _buildSuccessStep(context, provisioningState),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Paso 1: Escaneo de dispositivos
  Step _buildScanStep(BuildContext context, BleProvisioningState state) {
    final isActive = state.currentStep == 0;
    final isCompleted = state.currentStep > 0;

    return Step(
      title: Text(AppLocalizations.of(context)!.bleScanStepTitle),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.bleScanStepDescription,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          
          if (state.status == BleProvisioningStatus.scanning)
            const _ScanningAnimation()
          else if (isActive)
            CustomButton(
              text: AppLocalizations.of(context)!.bleScanButtonStart,
              onPressed: () {
                ref.read(bleProvisioningProvider.notifier).startScan();
              },
              type: ButtonType.primary,
              icon: Icons.bluetooth_searching,
            ),
          
          if (state.status == BleProvisioningStatus.error)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                state.errorMessage ?? AppLocalizations.of(context)!.bleErrorGeneric,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
              ),
            ),
        ],
      ),
      isActive: isActive,
      state: isCompleted ? StepState.complete : StepState.indexed,
    );
  }

  // Paso 2: Lista de dispositivos encontrados
  Step _buildDeviceListStep(BuildContext context, BleProvisioningState state) {
    final isActive = state.currentStep == 1;
    final isCompleted = state.currentStep > 1;

    return Step(
      title: Text(AppLocalizations.of(context)!.bleDeviceListStepTitle),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.foundDevices.isNotEmpty) ...[
            Text(
              AppLocalizations.of(context)!.bleDeviceListFound(state.foundDevices.length),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ...state.foundDevices.map((device) => _buildDeviceCard(device, state)),
          ],
        ],
      ),
      isActive: isActive,
      state: isCompleted ? StepState.complete : StepState.indexed,
    );
  }

  // Paso 3: Conectando y leyendo información
  Step _buildConnectionStep(BuildContext context, BleProvisioningState state) {
    final isActive = state.currentStep == 2;
    final isCompleted = state.currentStep > 2;

    return Step(
      title: Text(AppLocalizations.of(context)!.bleConnectionStepTitle),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.status == BleProvisioningStatus.connecting)
            const _ConnectingAnimation()
          else if (state.deviceDetails != null) ...[
            Text(
              AppLocalizations.of(context)!.bleDeviceInfoTitle,
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildDeviceInfoCard(state.deviceDetails!),
            const SizedBox(height: 24),
            CustomButton(
              text: AppLocalizations.of(context)!.bleConfigureButton,
              onPressed: () {
                ref.read(bleProvisioningProvider.notifier).goToStep(3);
              },
              type: ButtonType.primary,
              icon: Icons.settings,
            ),
          ],
        ],
      ),
      isActive: isActive,
      state: isCompleted ? StepState.complete : StepState.indexed,
    );
  }

  // Paso 4: Configuración del dispositivo
  Step _buildConfigurationStep(BuildContext context, BleProvisioningState state) {
    final isActive = state.currentStep == 3;
    final isCompleted = state.currentStep > 3;

    return Step(
      title: Text(AppLocalizations.of(context)!.bleConfigStepTitle),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.bleConfigStepDescription,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          
          CustomTextField(
            labelText: AppLocalizations.of(context)!.bleConfigDeviceNameLabel,
            hintText: AppLocalizations.of(context)!.bleConfigDeviceNameHint,
            controller: _deviceNameController,
            prefixIcon: Icons.device_hub,
          ),
          const SizedBox(height: 16),
          
          CustomTextField(
            labelText: AppLocalizations.of(context)!.bleConfigLocationLabel,
            hintText: AppLocalizations.of(context)!.bleConfigLocationHint,
            controller: _locationController,
            prefixIcon: Icons.location_on,
          ),
          const SizedBox(height: 16),
          
          CustomTextField(
            labelText: AppLocalizations.of(context)!.bleConfigDescriptionLabel,
            hintText: AppLocalizations.of(context)!.bleConfigDescriptionHint,
            controller: _descriptionController,
            prefixIcon: Icons.description,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          
          // Device Type Selector
          Text(
            AppLocalizations.of(context)!.bleConfigDeviceTypeLabel,
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildTypeChip('gate', AppLocalizations.of(context)!.bleConfigTypeGate)),
              const SizedBox(width: 8),
              Expanded(child: _buildTypeChip('door', AppLocalizations.of(context)!.bleConfigTypeDoor)),
              const SizedBox(width: 8),
              Expanded(child: _buildTypeChip('barrier', AppLocalizations.of(context)!.bleConfigTypeBarrier)),
            ],
          ),
          
          const SizedBox(height: 24),
          
          if (state.status == BleProvisioningStatus.configuring)
            const _ConfiguringAnimation()
          else
            CustomButton(
              text: AppLocalizations.of(context)!.bleConfigSaveButton,
              onPressed: _handleSaveConfiguration,
              type: ButtonType.primary,
              icon: Icons.save,
            ),
        ],
      ),
      isActive: isActive,
      state: isCompleted ? StepState.complete : StepState.indexed,
    );
  }

  // Paso 5: Éxito
  Step _buildSuccessStep(BuildContext context, BleProvisioningState state) {
    final isActive = state.currentStep == 4;

    return Step(
      title: Text(AppLocalizations.of(context)!.bleSuccessStepTitle),
      content: Column(
        children: [
          Icon(
            Icons.check_circle,
            size: 80,
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.bleSuccessMessage,
            style: AppTextStyles.headlineSmall.copyWith(
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (state.pendingConfig != null) ...[
            Text(
              AppLocalizations.of(context)!.bleSuccessDeviceConfigured(state.selectedDevice?.name ?? ""),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          CustomButton(
            text: AppLocalizations.of(context)!.bleSuccessGoToDevices,
            onPressed: () {
              ref.read(bleProvisioningProvider.notifier).disconnect();
              context.go('/devices');
            },
            type: ButtonType.primary,
            icon: Icons.devices,
          ),
        ],
      ),
      isActive: isActive,
      state: StepState.complete,
    );
  }

  Widget _buildDeviceCard(BleDeviceInfo device, BleProvisioningState state) {
    final isSelected = state.selectedDevice?.id == device.id;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          ref.read(bleProvisioningProvider.notifier).connectToDevice(device);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      device.serialNumber,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  _buildSignalIcon(device.rssi),
                  const SizedBox(height: 4),
                  Text(
                    '${device.rssi} dBm',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignalIcon(int rssi) {
    IconData icon;
    Color color;
    
    if (rssi >= -50) {
      icon = Icons.signal_wifi_4_bar;
      color = Colors.green;
    } else if (rssi >= -60) {
      icon = Icons.network_wifi_3_bar;
      color = Colors.orange;
    } else {
      icon = Icons.network_wifi_2_bar;
      color = Colors.red;
    }
    
    return Icon(icon, color: color, size: 24);
  }

  Widget _buildDeviceInfoCard(DeviceDetails details) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(AppLocalizations.of(context)!.bleInfoSerial, details.serialNumber),
            _buildInfoRow(AppLocalizations.of(context)!.bleInfoFirmware, details.firmwareVersion),
            _buildInfoRow(AppLocalizations.of(context)!.bleInfoModel, details.model),
            _buildInfoRow(AppLocalizations.of(context)!.bleInfoMotor, details.motorType),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String value, String label) {
    final isSelected = _selectedDeviceType == value;
    
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedDeviceType = value;
          });
        }
      },
      selectedColor: AppColors.primaryPurple.withValues(alpha: 0.2),
      labelStyle: AppTextStyles.bodySmall.copyWith(
        color: isSelected ? AppColors.primaryPurple : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  void _handleSaveConfiguration() {
    final config = DeviceConfiguration(
      deviceName: _deviceNameController.text.trim(),
      location: _locationController.text.trim(),
      description: _descriptionController.text.trim(),
      deviceType: _selectedDeviceType,
    );

    if (config.deviceName.isEmpty) {
      SnackbarHelper.showError(
        context, 
        AppLocalizations.of(context)!.bleConfigDeviceNameRequired,
      );
      return;
    }

    ref.read(bleProvisioningProvider.notifier).configureDevice(config);
  }
}

// Widgets de animación
class _ScanningAnimation extends StatefulWidget {
  const _ScanningAnimation();

  @override
  State<_ScanningAnimation> createState() => _ScanningAnimationState();
}

class _ScanningAnimationState extends State<_ScanningAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: 0.8 + (_controller.value * 0.4),
              child: CircularProgressIndicator(
                value: null,
                color: AppColors.primaryPurple,
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.bleScanningText,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primaryPurple,
          ),
        ),
      ],
    );
  }
}

class _ConnectingAnimation extends StatelessWidget {
  const _ConnectingAnimation();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularProgressIndicator(
          color: AppColors.primaryPurple,
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.bleConnectingText,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primaryPurple,
          ),
        ),
      ],
    );
  }
}

class _ConfiguringAnimation extends StatelessWidget {
  const _ConfiguringAnimation();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularProgressIndicator(
          color: AppColors.primaryPurple,
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.bleConfiguringText,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primaryPurple,
          ),
        ),
      ],
    );
  }
}