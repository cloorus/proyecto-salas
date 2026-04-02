import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
// import '../../../../core/constants/app_messages.dart'; // Removed - using AppLocalizations instead
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/device_header.dart';
import '../../../../shared/widgets/control_buttons_panel.dart';
import '../../../../shared/widgets/snackbar_helper.dart';
import '../../../../shared/widgets/info_section.dart';
import '../../../../core/services/device_service.dart';
import '../../domain/entities/device.dart';

/// Pantalla de Control de Dispositivo
class DeviceControlScreen extends StatefulWidget {
  final String deviceId;

  const DeviceControlScreen({
    super.key,
    required this.deviceId,
  });

  @override
  State<DeviceControlScreen> createState() => _DeviceControlScreenState();
}

class _DeviceControlScreenState extends State<DeviceControlScreen> {
  late Device device;
  bool _isExecuting = false;
  DeviceCommand? _currentCommand;

  bool _isLoadingDevice = true;

  @override
  void initState() {
    super.initState();
    _loadDevice();
  }

  Future<void> _loadDevice() async {
    try {
      final d = await DeviceService.instance.getDeviceById(widget.deviceId);
      if (mounted) setState(() { device = d; _isLoadingDevice = false; });
    } catch (e) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.pop();
        });
      }
    }
  }

  Future<void> _executeCommand(DeviceCommand command) async {
    final l10n = AppLocalizations.of(context)!;
    
    if (!device.isOnline) {
      SnackbarHelper.showError(context, l10n.msgDeviceOffline);
      return;
    }

    setState(() {
      _isExecuting = true;
      _currentCommand = command;
    });

    // Mostrar mensaje del comando
    String message;
    switch (command) {
      case DeviceCommand.open:
        message = l10n.deviceStatusOpening;
        break;
      case DeviceCommand.close:
        message = l10n.deviceStatusClosing;
        break;
      case DeviceCommand.pause:
        message = l10n.deviceStatusPaused;
        break;
      case DeviceCommand.pedestrian:
        message = l10n.deviceStatusPedestrianActive;
        break;
    }
    SnackbarHelper.showInfo(context, message);

    // Enviar comando real a la API (no bloquear UI)
    final commandMap = {
      DeviceCommand.open: 'OPEN',
      DeviceCommand.close: 'CLOSE',
      DeviceCommand.pause: 'STOP',
      DeviceCommand.pedestrian: 'PEDESTRIAN',
    };
    
    try {
      await DeviceService.instance.sendCommand(widget.deviceId, commandMap[command]!);
      if (!mounted) return;
      setState(() {
        _isExecuting = false;
        _currentCommand = null;
      });
      SnackbarHelper.showSuccess(context, l10n.msgCommandSuccess);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isExecuting = false;
        _currentCommand = null;
      });
      SnackbarHelper.showWarning(context, 'Comando enviado, esperando respuesta del dispositivo...');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingDevice) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            PageHeader(
              title: device.name,
              showBackButton: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header del dispositivo
                    DeviceHeader(
                      model: device.model,
                      serialNumber: device.serialNumber,
                      isOnline: device.isOnline,
                      onDetailPressed: () {
                        context.push('/devices/${widget.deviceId}/detail');
                      },
                    ),
                    const SizedBox(height: 24),

                    // Título de controles
                    Text(
                      AppLocalizations.of(context)!.deviceControlSimpleTitle,
                      style: AppTextStyles.sectionTitle,
                    ),
                    const SizedBox(height: 16),

                    // Panel de control
                    ControlButtonsPanel(
                      onCommandPressed: _executeCommand,
                      isExecuting: _isExecuting,
                      currentCommand: _currentCommand,
                    ),
                    const SizedBox(height: 24),

                    // Información adicional
                    if (device.location != null) ...[
                      InfoSection(
                        icon: Icons.location_on_outlined,
                        title: AppLocalizations.of(context)!.deviceControlLocationTitle,
                        content: device.location!,
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (device.description != null) ...[
                      InfoSection(
                        icon: Icons.info_outline,
                        title: AppLocalizations.of(context)!.deviceControlDescriptionTitle,
                        content: device.description!,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Estado actual
                    InfoSection(
                      icon: Icons.info_outline,
                      title: AppLocalizations.of(context)!.deviceControlStatusTitle,
                      content: device.status.displayName,
                      contentColor: device.status.color,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
