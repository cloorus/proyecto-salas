import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../domain/entities/device.dart';
import '../providers/permissions_provider.dart';

/// Pantalla de Detalle del Dispositivo
/// Consumidor de Permisos Mockeados
class DeviceDetailScreen extends ConsumerStatefulWidget {
  final String deviceId;
  final Device? device;

  const DeviceDetailScreen({
    super.key,
    required this.deviceId,
    this.device,
  });

  @override
  ConsumerState<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends ConsumerState<DeviceDetailScreen> {
  // Estado simulado
  String _statusText = '';
  // Timers y Visibilidad
  Timer? _messageTimer;
  Timer? _countdownTimer;
  int _remainingSeconds = 20;
  bool _showStatusPanel = false;
  bool _showCountdownPanel = false;
  bool _isExecuting = false;

  @override
  void initState() {
    super.initState();
    // Inicializar permisos por defecto si está vacío (para demos)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentPerms = ref.read(permissionsProvider)[widget.deviceId];
      if (currentPerms == null) {
        // Default Full Access for demo unless restricted
        if (widget.device?.name == 'ETC' || widget.device?.id == '6') {
             ref.read(permissionsProvider.notifier).setPermissions(widget.deviceId, {
            'open', 'close', 'pause', 'pedestrian', 'control_panel', 
            'lock', 'light', 'aux_switch' // Guest allowed controls, no management
          });
        } else {
             ref.read(permissionsProvider.notifier).setPermissions(widget.deviceId, {
            'open', 'close', 'pause', 'pedestrian', 'control_panel',
            'lock', 'light', 'aux_switch',
            'view_events', 'view_users', 'view_contact', 'view_params', 'edit_device'
          });
        }
      }
    });
  }

  bool _checkPermission(String action) {
    // Leer del provider
    final perms = ref.watch(permissionsProvider)[widget.deviceId];
    // Si no hay permisos cargados aún, asumir true mientras carga (o false seguro)
    // Asumir false por seguridad, pero para evitar parpadeo en init, true si es owner (demo)
    if (perms == null) return true; 
    return perms.contains(action);
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _handleCommand(String command, String message) {
    if (_isExecuting) return;

    setState(() {
      _isExecuting = true;
      _statusText = message;
      _showStatusPanel = true;
      
      // Si enviamos otro comando, ocultamos el contador anterior si existía
      if (command != 'ABRIR') {
        _cancelAutoClose();
      }
    });

    // Ocultar mensaje después de 5 segundos
    _messageTimer?.cancel();
    _messageTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _showStatusPanel = false);
      }
    });

    // Simular ejecución
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _isExecuting = false);
      
      // Si es comando ABRIR, iniciar cuenta regresiva
      if (command == 'ABRIR') {
        _startAutoCloseCountdown();
      }
    });
  }

  void _startAutoCloseCountdown() {
    _cancelAutoClose(); // Reiniciar si ya existe
    setState(() {
      _showCountdownPanel = true;
      _remainingSeconds = 20;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _cancelAutoClose(); // Ocultar al terminar
            // Opcional: Mostrar mensaje de "Cerrando..." aquí
          }
        });
      }
    });
  }

  void _cancelAutoClose() {
    _countdownTimer?.cancel();
    setState(() => _showCountdownPanel = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Header
            PageHeader(
              title: widget.device?.name ?? AppLocalizations.of(context)!.deviceControlTitle,
              titleFontSize: 24,
              showBackButton: true,
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Imagen Principal (Portón)
                    Container(
                      height: 220,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Semantics(
                        label: AppLocalizations.of(context)!.deviceImageLabel,
                        child: Container(
                          width: double.infinity,
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            image: widget.device?.imageUrl != null && widget.device!.imageUrl!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(widget.device!.imageUrl!),
                                  fit: BoxFit.cover,
                                  onError: (error, stackTrace) {
                                    debugPrint('DETAIL IMAGE ERROR: $error');
                                  },
                                )
                              : const DecorationImage(
                                  image: AssetImage('assets/images/porton_fondo.png'),
                                  fit: BoxFit.cover,
                                  opacity: 0.3,
                                ),
                          ),
                          child: widget.device?.imageUrl == null || widget.device!.imageUrl!.isEmpty
                            ? const Center(child: Icon(Icons.image_outlined, size: 50, color: Colors.grey))
                            : null,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Panel de Control
                    if (_checkPermission('control_panel'))
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5), // Gris claro
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (_checkPermission('open'))
                              _ControlButton(
                                icon: Icons.arrow_forward,
                                label: AppLocalizations.of(context)!.deviceControlButtonOpen,
                                color: Colors.green,
                                isCircle: true,
                                onTap: () => _handleCommand('ABRIR', AppLocalizations.of(context)!.deviceControlStatusOpening),
                              ),
                            if (_checkPermission('pause'))
                              _ControlButton(
                                icon: Icons.pause,
                                label: AppLocalizations.of(context)!.deviceControlButtonPause,
                                color: AppColors.textSecondary,
                                isCircle: false,
                                onTap: () => _handleCommand('PAUSA', AppLocalizations.of(context)!.deviceControlStatusPausing),
                              ),
                            if (_checkPermission('close'))
                              _ControlButton(
                                icon: Icons.arrow_back,
                                label: AppLocalizations.of(context)!.deviceControlButtonClose,
                                color: Colors.orange,
                                isCircle: true,
                                onTap: () => _handleCommand('CERRAR', AppLocalizations.of(context)!.deviceControlStatusClosing),
                              ),
                            if (_checkPermission('pedestrian'))
                              _ControlButton(
                                icon: Icons.directions_walk,
                                label: AppLocalizations.of(context)!.deviceControlButtonPedestrian,
                                color: Colors.blue,
                                isCircle: false,
                                onTap: () => _handleCommand('PEATONAL', AppLocalizations.of(context)!.deviceControlStatusPedestrian),
                              ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Panel Auxiliar (Bloqueo, Lámpara, Switch)
                    if (_checkPermission('control_panel'))
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (_checkPermission('lock'))
                              _ControlButton(
                                icon: Icons.lock_outline,
                                label: AppLocalizations.of(context)!.deviceControlButtonLock,
                                color: AppColors.error,
                                isCircle: true,
                                onTap: () => _handleCommand('BLOQUEO', AppLocalizations.of(context)!.deviceControlStatusLocked),
                              ),
                            if (_checkPermission('light'))
                              _ControlButton(
                                icon: Icons.light_mode_outlined,
                                label: AppLocalizations.of(context)!.deviceControlButtonLight,
                                color: Colors.amber,
                                isCircle: true,
                                onTap: () => _handleCommand('LUZ', AppLocalizations.of(context)!.deviceControlStatusLightOn),
                              ),
                            if (_checkPermission('aux_switch'))
                              _ControlButton(
                                icon: Icons.toggle_on_outlined,
                                label: AppLocalizations.of(context)!.deviceControlButtonSwitch,
                                color: AppColors.primaryPurple,
                                isCircle: true,
                                onTap: () => _handleCommand('SWITCH', AppLocalizations.of(context)!.deviceControlStatusSwitchActive),
                              ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Estado: Texto Grande
                    if (_showStatusPanel)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Semantics(
                          liveRegion: true,
                          child: Text(
                            _statusText,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    
                    if (_showStatusPanel && _showCountdownPanel)
                      const SizedBox(height: 8),

                    // Estado: Tiempo Restante
                    if (_showCountdownPanel)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 50),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Semantics(
                          liveRegion: true,
                          child: Text(
                            AppLocalizations.of(context)!.deviceControlAutoCloseCountdown(_remainingSeconds),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 30),

                    // Acciones de Gestión
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          if (_checkPermission('edit_device'))
                            _ManagementLink(
                              icon: Icons.edit_note,
                              label: AppLocalizations.of(context)!.deviceControlLinkEdit,
                              onTap: () => context.push('/devices/${widget.deviceId}/edit'),
                            ),
                          const SizedBox(height: 12),
                          if (_checkPermission('view_users'))
                            _ManagementLink(
                              icon: Icons.people_outline,
                              label: AppLocalizations.of(context)!.deviceControlLinkUsers,
                              onTap: () => context.push(
                                '/devices/${widget.deviceId}/registered-users',
                                extra: widget.device,
                              ),
                            ),
                          const SizedBox(height: 12),
                          if (_checkPermission('view_params'))
                            _ManagementLink(
                              icon: Icons.settings_remote,
                              label: AppLocalizations.of(context)!.deviceControlLinkParams,
                              onTap: () => context.push('/devices/${widget.deviceId}/parameters'),
                            ),
                          
                          const SizedBox(height: 32),

                          if (_checkPermission('view_events'))
                            _ManagementLink(
                              icon: Icons.history,
                              label: AppLocalizations.of(context)!.deviceControlLinkEvents,
                              onTap: () => context.push('/devices/${widget.deviceId}/events'),
                            ),
                          const SizedBox(height: 12),
                          if (_checkPermission('view_contact'))
                            _ManagementLink(
                              icon: Icons.build_circle_outlined,
                              label: AppLocalizations.of(context)!.deviceControlLinkContact,
                              onTap: () => context.push(
                                '/devices/${widget.deviceId}/technical-contact', 
                                extra: widget.device
                              ),
                            ),
                          
                          const SizedBox(height: 32),

                          _ManagementLink(
                            icon: Icons.info_outline,
                            label: AppLocalizations.of(context)!.deviceControlLinkInfo,
                            onTap: () => context.push('/devices/${widget.deviceId}/info'),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
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

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isCircle;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isCircle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          if (isCircle)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 30),
            )
          else
            Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                child: Icon(icon,
                    color: color,
                    size: 40)),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
        ],
        ),
      ),
    );
  }
}

class _ManagementLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ManagementLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryPurple, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
          ],
        ),
        ),
      ),
    );
  }
}
