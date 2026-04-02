import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/curved_tab_bar.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../core/services/device_service.dart';
import '../../domain/entities/device.dart';
import '../widgets/device_image_card.dart';
import '../../../../shared/widgets/control_buttons_panel.dart';
import '../../../../shared/widgets/notification_bell.dart';
import '../widgets/quick_controls_bottom_sheet.dart';

/// Pantalla principal de lista de dispositivos
class DevicesListScreen extends StatefulWidget {
  const DevicesListScreen({super.key});

  @override
  State<DevicesListScreen> createState() => _DevicesListScreenState();
}

class _DevicesListScreenState extends State<DevicesListScreen> {
  int _selectedTabIndex = 0;
  String _statusText = '';
  String? _activeDeviceName;

  List<Device> _devices = [];
  bool _isLoading = true;
  String? _loadError;

  Timer? _messageTimer;
  Timer? _countdownTimer;
  int _remainingSeconds = 0;
  bool _showStatusPanel = false;
  bool _showCountdownPanel = false;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    setState(() { _isLoading = true; _loadError = null; });
    try {
      final devices = await DeviceService.instance.getDevices();
      if (mounted) setState(() { _devices = devices; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _loadError = e.toString(); _isLoading = false; });
    }
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _handleCommand(DeviceCommand command, String deviceName) {
    _messageTimer?.cancel();

    setState(() {
      _activeDeviceName = deviceName;
      _showStatusPanel = true;
      switch (command) {
        case DeviceCommand.open:
          _statusText = AppLocalizations.of(context)!.deviceStatusOpening;
          _startAutoCloseCountdown();
          break;
        case DeviceCommand.close:
          _statusText = AppLocalizations.of(context)!.deviceStatusClosing;
          _cancelAutoClose();
          break;
        case DeviceCommand.pause:
          _statusText = AppLocalizations.of(context)!.deviceStatusPaused;
          _cancelAutoClose();
          break;
        case DeviceCommand.pedestrian:
          _statusText = AppLocalizations.of(context)!.deviceStatusPedestrianActive;
          break;
      }
    });

    _messageTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showStatusPanel = false;
        });
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _showStatusPanel) {
        setState(() {
          _statusText = AppLocalizations.of(context)!.deviceStatusReady;
        });
      }
    });
  }

  void _startAutoCloseCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _remainingSeconds = 20;
      _showCountdownPanel = true;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_remainingSeconds > 0) {
          setState(() => _remainingSeconds--);
        } else {
          timer.cancel();
          setState(() => _showCountdownPanel = false);
        }
      }
    });
  }

  void _cancelAutoClose() {
    _countdownTimer?.cancel();
    setState(() => _showCountdownPanel = false);
  }

  @override
  Widget build(BuildContext context) {
    final currentList = _devices;

    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      body: Column(
        children: [
          // Fondo blanco para header y tabs
          Container(
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 16),
                PageHeader(
                  title: AppLocalizations.of(context)!.devicesListTitle,
                  titleFontSize: 24.0,
                ),
                CurvedTabBar(
                  tabs: [AppLocalizations.of(context)!.devicesTabDevices, AppLocalizations.of(context)!.devicesTabOthers],
                  selectedIndex: _selectedTabIndex,
                  onTabChanged: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  onAddPressed: () {
                    context.push('/devices/add');
                  },
                ),
              ],
            ),
          ),

          // Grid de tarjetas
          Expanded(
            child: currentList.isNotEmpty
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: currentList.length,
                    itemBuilder: (context, index) {
                      final device = currentList[index];
                      return DeviceImageCard(
                        device: device,
                        onTap: () {
                          showQuickControlsSheet(
                            context: context,
                            device: device,
                            onCommand: (cmd) =>
                                _handleCommand(cmd, device.name),
                          );
                        },
                        onDoubleTap: () {
                          context.pushNamed(
                            'device-detail',
                            pathParameters: {'id': device.id},
                            extra: device,
                          );
                        },
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey[400],
                          semanticLabel: AppLocalizations.of(context)!.emptyListMessage,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.emptyListMessage,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          // Panel de estado (aparece después de un comando)
          if (_showStatusPanel) ...[
            Semantics(
              label: _activeDeviceName != null ? '$_activeDeviceName: $_statusText' : _statusText,
              container: true,
              liveRegion: true,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primaryPurple.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      if (_activeDeviceName != null)
                        Text(
                          _activeDeviceName!,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      Text(
                        _statusText,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryPurple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          // Countdown panel
          if (_showCountdownPanel) ...[
            Semantics(
              label: AppLocalizations.of(context)!.deviceAutoCloseCountdown(_remainingSeconds),
              container: true,
              liveRegion: true,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.deviceAutoCloseCountdown(_remainingSeconds),
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warning,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],

          if (!_showStatusPanel && !_showCountdownPanel)
            const SizedBox(height: 8),
        ],
      ),
      floatingActionButton: const NotificationFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
