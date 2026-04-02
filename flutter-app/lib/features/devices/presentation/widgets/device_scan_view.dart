import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';

class DeviceScanView extends ConsumerStatefulWidget {
  final VoidCallback? onScanComplete;
  final Object? parentDevice; // Keeping signature compatible

  const DeviceScanView({
    super.key,
    this.onScanComplete,
    this.parentDevice,
  });

  @override
  ConsumerState<DeviceScanView> createState() => _DeviceScanViewState();
}

class _DeviceScanViewState extends ConsumerState<DeviceScanView> {

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryPurple.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícono BLE
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bluetooth,
                size: 48,
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: 16),

            // Título y descripción
            Text(
              l10n.blePairingTitle,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.primaryPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Empareja tu dispositivo VITA usando Bluetooth Low Energy para una configuración rápida y segura.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Características del nuevo flujo BLE
            Column(
              children: [
                _buildFeatureItem(
                  Icons.speed,
                  'Conexión rápida',
                  'Emparejamiento en menos de 30 segundos',
                ),
                const SizedBox(height: 12),
                _buildFeatureItem(
                  Icons.security,
                  'Configuración segura',
                  'Comunicación encriptada via BLE',
                ),
                const SizedBox(height: 12),
                _buildFeatureItem(
                  Icons.settings,
                  'Configuración completa',
                  'Configura nombre, ubicación y tipo',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Botón para iniciar flujo BLE
            CustomButton(
              text: 'Iniciar emparejamiento BLE',
              onPressed: () {
                context.push('/devices/ble-pairing');
              },
              type: ButtonType.primary,
              icon: Icons.bluetooth_connected,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.primaryPurple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}