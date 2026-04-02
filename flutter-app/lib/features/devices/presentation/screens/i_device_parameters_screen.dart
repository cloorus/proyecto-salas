import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/snackbar_helper.dart';

/// Pantalla de Parámetros del Dispositivo
/// Según mockup 13_parametros_del_dispositivo.png
class DeviceParametersScreen extends StatefulWidget {
  final String deviceId;

  const DeviceParametersScreen({
    super.key,
    required this.deviceId,
  });

  @override
  State<DeviceParametersScreen> createState() => _DeviceParametersScreenState();
}

class _DeviceParametersScreenState extends State<DeviceParametersScreen> {
  // Estado local de los parámetros
  bool _bloquearDispositivo = true;
  bool _recordatorioDesconexion = true;
  bool _recordatorioPuertaAbierta = false;
  bool _alarmaAperturaForzada = true;
  bool _mantenerAbierto = true;
  bool _cierreAutomatico = true;
  bool _tiempoCierreAutomatico = true; // En el mockup se ve como switch
  bool _luzCortesia = true;

  // Nuevos parámetros (Config Notificaciones)
  bool _fotoCeldaBloqueada = false;
  bool _aperturaNoPermitida = false;
  bool _actualizacionDisponible = true;
  bool _solicitudMantenimiento = false;
  bool _tiempoRecordatorioPuertaAbierta = true;
  bool _tiempoFaltaConexion = true;
  bool _tiempoFotoCeldaBloqueada = false;

  void _updateParameters() {
    // Simular actualización
    SnackbarHelper.showSuccess(
        context, AppLocalizations.of(context)!.parametersUpdatedSuccess);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) context.pop();
    });
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
              title: AppLocalizations.of(context)!.parametersTitle,
              titleFontSize: 22,
              showBackButton: true,
            ),

            // Información del Dispositivo (Panel Gris)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              color: const Color(0xFFF5F5F5), // Gris claro
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.parametersDeviceLabel,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.parametersModelLabel} FAC 500 Vita',
                              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${AppLocalizations.of(context)!.parametersSerialLabel} 123456',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.parametersStateLabel} ${AppLocalizations.of(context)!.deviceOnlineStatus}',
                              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${AppLocalizations.of(context)!.parametersDetailLabel} motor casa',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Lista de Parámetros
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  // SECCIÓN 1: Config Parámetros
                  _SectionHeader(title: AppLocalizations.of(context)!.parametersConfigSection),
                  _ParameterSwitch(
                    label: AppLocalizations.of(context)!.parametersAutoClose,
                    value: _cierreAutomatico,
                    onChanged: (val) => setState(() => _cierreAutomatico = val),
                  ),
                  _ParameterSwitch(
                    label: AppLocalizations.of(context)!.parametersCourtesyLight,
                    value: _luzCortesia,
                    onChanged: (val) => setState(() => _luzCortesia = val),
                  ),
                  _ParameterSwitch(
                    label: AppLocalizations.of(context)!.parametersAutoCloseTime,
                    value: _tiempoCierreAutomatico,
                    onChanged: (val) =>
                        setState(() => _tiempoCierreAutomatico = val),
                  ),
                  // Mantenemos los existentes relevantes aquí
                  _ParameterSwitch(
                    label: AppLocalizations.of(context)!.parametersLockDevice,
                    value: _bloquearDispositivo,
                    onChanged: (val) =>
                        setState(() => _bloquearDispositivo = val),
                  ),
                  _ParameterSwitch(
                    label: AppLocalizations.of(context)!.parametersKeepOpen,
                    value: _mantenerAbierto,
                    onChanged: (val) => setState(() => _mantenerAbierto = val),
                  ),

                  const SizedBox(height: 24),

                  // SECCIÓN 2: Config Notificaciones
                  _SectionHeader(title: AppLocalizations.of(context)!.parametersNotificationsSection),
                  _ParameterSwitch(
                    label: AppLocalizations.of(context)!.parametersDisconnectionReminder,
                    value: _recordatorioDesconexion,
                    onChanged: (val) =>
                        setState(() => _recordatorioDesconexion = val),
                  ),
                  _ParameterSwitch(
                    label: AppLocalizations.of(context)!.parametersOpenDoorReminder,
                    value: _recordatorioPuertaAbierta,
                    onChanged: (val) =>
                        setState(() => _recordatorioPuertaAbierta = val),
                  ),
                  _ParameterSwitch(
                    label: AppLocalizations.of(context)!.parametersForcedOpeningAlarm,
                    value: _alarmaAperturaForzada,
                    onChanged: (val) =>
                        setState(() => _alarmaAperturaForzada = val),
                  ),
                  _ParameterSwitch(
                    label: AppLocalizations.of(context)!.parametersPhotocellBlocked,
                    value: _fotoCeldaBloqueada,
                    onChanged: (val) => setState(() => _fotoCeldaBloqueada = val),
                  ),
                   _ParameterSwitch(
                    label: AppLocalizations.of(context)!.parametersOpeningNotAllowed,
                    value: _aperturaNoPermitida,
                    onChanged: (val) => setState(() => _aperturaNoPermitida = val),
                  ),
                   _ParameterSwitch(
                    label: AppLocalizations.of(context)!.parametersUpdateAvailable,
                    value: _actualizacionDisponible,
                    onChanged: (val) => setState(() => _actualizacionDisponible = val),
                  ),
                   _ParameterSwitch(
                    label: AppLocalizations.of(context)!.parametersMaintenanceRequest,
                    value: _solicitudMantenimiento,
                    onChanged: (val) => setState(() => _solicitudMantenimiento = val),
                  ),
                   _ParameterSwitch(
                    label: AppLocalizations.of(context)!.parametersOpenDoorReminderTime,
                    value: _tiempoRecordatorioPuertaAbierta,
                    onChanged: (val) => setState(() => _tiempoRecordatorioPuertaAbierta = val),
                  ),
                   _ParameterSwitch(
                    label: AppLocalizations.of(context)!.parametersConnectionFailureTime,
                    value: _tiempoFaltaConexion,
                    onChanged: (val) => setState(() => _tiempoFaltaConexion = val),
                  ),
                   _ParameterSwitch(
                    label: AppLocalizations.of(context)!.parametersPhotocellBlockedTime,
                    value: _tiempoFotoCeldaBloqueada,
                    onChanged: (val) => setState(() => _tiempoFotoCeldaBloqueada = val),
                  ),
                ],
              ),
            ),

            // Botón Actualizar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: CustomButton(
                text: AppLocalizations.of(context)!.parametersUpdateButton,
                onPressed: _updateParameters,
                type: ButtonType.primary,
                backgroundColor: const Color(0xFF0D6EFD),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParameterSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ParameterSwitch({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: ${value ? 'Activado' : 'Desactivado'}',
      button: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.titleBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            Transform.scale(
              scale: 0.9,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: AppColors.titleBlue,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade300,
                trackOutlineColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.titleBlue,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
