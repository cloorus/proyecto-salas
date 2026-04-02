import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Header de información de dispositivo
/// 
/// Card gris con información del dispositivo:
/// - Modelo
/// - Número de Serie
/// - Estado (En línea/Sin conexión)
/// - Botón de detalle
class DeviceHeader extends StatelessWidget {
  final String model;
  final String serialNumber;
  final bool isOnline;
  final VoidCallback? onDetailPressed;

  const DeviceHeader({
    super.key,
    required this.model,
    required this.serialNumber,
    required this.isOnline,
    this.onDetailPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.deviceHeader,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modelo
          Row(
            children: [
              Icon(
                Icons.router_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.modelLabel,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  model,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Número de Serie
          Row(
            children: [
              Icon(
                Icons.qr_code,
                color: AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.serialNumberLabel,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  serialNumber,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Estado y Detalle
          Row(
            children: [
              Icon(
                Icons.circle,
                color: isOnline ? AppColors.success : AppColors.error,
                size: 12,
              ),
              const SizedBox(width: 8),
              Text(
                isOnline 
                  ? AppLocalizations.of(context)!.deviceOnlineStatus 
                  : AppLocalizations.of(context)!.deviceOfflineStatus,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isOnline ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              
              // Botón Detalle
              if (onDetailPressed != null)
                TextButton.icon(
                  onPressed: onDetailPressed,
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: Text(AppLocalizations.of(context)!.detailLabel),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondaryBlue,
                    textStyle: AppTextStyles.bodySmall,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
