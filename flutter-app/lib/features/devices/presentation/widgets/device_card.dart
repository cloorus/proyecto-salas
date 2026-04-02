import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/device.dart';

/// Card de dispositivo horizontal compacto según mockup 3_dispositivos.png
/// Layout: [Icono] [Info] [Estado] [Botones]
class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback onTap;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shadowColor: AppColors.cardShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.divider,
          width: 0.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Icono del dispositivo (pequeño)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: device.isOnline
                      ? AppColors.primaryPurple.withValues(alpha: 0.1)
                      : AppColors.textDisabled.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  device.type.icon,
                  color: device.isOnline
                      ? AppColors.primaryPurple
                      : AppColors.textDisabled,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              
              // Información del dispositivo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre
                    Text(
                      device.name,
                      style: AppTextStyles.cardTitle.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // Modelo
                    Text(
                      device.model,
                      style: AppTextStyles.deviceInfo.copyWith(
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Estado en línea/desconectado
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: device.isOnline
                                ? AppColors.statusOnline
                                : AppColors.statusOffline,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          device.isOnline ? 'En línea' : 'Desconectado',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: device.isOnline
                                ? AppColors.statusOnline
                                : AppColors.statusOffline,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Icono de ir a detalles
              Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
