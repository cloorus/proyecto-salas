import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/theme/app_colors.dart';

/// Tipo de comando para el dispositivo
enum DeviceCommand {
  open,
  close,
  pause,
  pedestrian,
}

/// Panel flotante de botones de control según mockup
/// 
/// Fondo gris claro (#E0E0E0), esquinas redondeadas, sombra
/// 4 botones distribuidos uniformemente:
/// - Abrir: flecha verde→ con círculo bordeado
/// - Pausa: icono pausa
/// - Cerrar: flecha naranja← con círculo bordeado  
/// - Peatonal: silueta azul caminando
class ControlButtonsPanel extends StatelessWidget {
  final Function(DeviceCommand) onCommandPressed;
  final bool isExecuting;
  final DeviceCommand? currentCommand;

  const ControlButtonsPanel({
    super.key,
    required this.onCommandPressed,
    this.isExecuting = false,
    this.currentCommand,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0), // Gris claro del mockup
        borderRadius: BorderRadius.circular(24), // Esquinas generosamente redondeadas
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Botón Abrir
          _ControlButton(
            label: AppLocalizations.of(context)!.controlsButtonOpen,
            icon: Icons.arrow_forward,
            iconColor: AppColors.primaryPurple, // Uniforme púrpura
            onPressed: !isExecuting ? () => onCommandPressed(DeviceCommand.open) : null,
            isExecuting: isExecuting && currentCommand == DeviceCommand.open,
          ),
          
          // Botón Pausa
          _ControlButton(
            label: AppLocalizations.of(context)!.controlsButtonPause,
            icon: Icons.pause, // Icono estándar
            iconColor: AppColors.primaryPurple, // Uniforme púrpura
            onPressed: !isExecuting ? () => onCommandPressed(DeviceCommand.pause) : null,
            isExecuting: isExecuting && currentCommand == DeviceCommand.pause,
          ),
          
          // Botón Cerrar
          _ControlButton(
            label: AppLocalizations.of(context)!.controlsButtonClose,
            icon: Icons.arrow_back,
            iconColor: AppColors.primaryPurple, // Uniforme púrpura
            onPressed: !isExecuting ? () => onCommandPressed(DeviceCommand.close) : null,
            isExecuting: isExecuting && currentCommand == DeviceCommand.close,
          ),
          
          // Botón Peatonal
          _ControlButton(
            label: AppLocalizations.of(context)!.controlsButtonPedestrian,
            icon: Icons.directions_walk,
            iconColor: AppColors.primaryPurple, // Uniforme púrpura
            onPressed: !isExecuting ? () => onCommandPressed(DeviceCommand.pedestrian) : null,
            isExecuting: isExecuting && currentCommand == DeviceCommand.pedestrian,
          ),
        ],
      ),
    );
  }
}

/// Botón individual de control con estilo neumórfico
class _ControlButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onPressed;
  final bool isExecuting;

  const _ControlButton({
    required this.label,
    required this.icon,
    required this.iconColor,
    this.onPressed,
    this.isExecuting = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Botón neumórfico
            SizedBox(
              width: 60,
              height: 60,
              child: isExecuting
                  ? Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF0F0F0),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF616161)),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      // Contenedor exterior con gradiente y sombra externa
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: isEnabled
                              ? [
                                  Colors.white,
                                  const Color(0xFFF0F0F0),
                                ]
                              : [
                                  const Color(0xFFE0E0E0),
                                  const Color(0xFFD0D0D0),
                                ],
                        ),
                        boxShadow: [
                          // Sombra exterior inferior
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                          // Sombra interior superior (efecto de borde)
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.8),
                            blurRadius: 1,
                            offset: const Offset(0, -1),
                            spreadRadius: 0,
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: _buildCircularIcon(isEnabled),
                      ),
                    ),
            ),
            // Texto del label (siempre visible según diseño original)
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.montserrat(
                color: isEnabled ? Colors.black87 : Colors.grey[400],
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el círculo interior con icono
  Widget _buildCircularIcon(bool isEnabled) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFF5F5F5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 2,
            offset: const Offset(0, 1),
            spreadRadius: -1,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: isEnabled ? iconColor : const Color(0xFFBDBDBD),
          size: 24,
        ),
      ),
    );
  }
}
