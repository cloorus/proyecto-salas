import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/control_buttons_panel.dart';
import '../../domain/entities/device.dart';

/// Muestra el bottom sheet de controles rápidos para un dispositivo
void showQuickControlsSheet({
  required BuildContext context,
  required Device device,
  required Function(DeviceCommand) onCommand,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _QuickControlsSheet(
      device: device,
      onCommand: onCommand,
    ),
  );
}

class _QuickControlsSheet extends StatelessWidget {
  final Device device;
  final Function(DeviceCommand) onCommand;

  const _QuickControlsSheet({
    required this.device,
    required this.onCommand,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Nombre del dispositivo
          Row(
            children: [
              if (device.isPrimary)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Principal',
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
              Expanded(
                child: Text(
                  device.name,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Estado online
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: device.isOnline
                      ? AppColors.statusOnline.withValues(alpha: 0.12)
                      : AppColors.statusOffline.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: device.isOnline
                            ? AppColors.statusOnline
                            : AppColors.statusOffline,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      device.isOnline ? 'En línea' : 'Sin conexión',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: device.isOnline
                            ? AppColors.statusOnline
                            : AppColors.statusOffline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Modelo
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              device.model,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Botones de control
          ControlButtonsPanel(
            onCommandPressed: (cmd) {
              Navigator.of(context).pop();
              onCommand(cmd);
            },
            isExecuting: false,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
