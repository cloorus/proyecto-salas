import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/custom_switch.dart';

/// Modelo de preferencias de notificación por dispositivo
class NotificationPreferences {
  final String deviceId;
  final String deviceName;
  final bool notifyActions;
  final bool notifyOffline;
  final bool notifyStatusChange;

  const NotificationPreferences({
    required this.deviceId,
    required this.deviceName,
    required this.notifyActions,
    required this.notifyOffline,
    required this.notifyStatusChange,
  });

  NotificationPreferences copyWith({
    bool? notifyActions,
    bool? notifyOffline,
    bool? notifyStatusChange,
  }) {
    return NotificationPreferences(
      deviceId: deviceId,
      deviceName: deviceName,
      notifyActions: notifyActions ?? this.notifyActions,
      notifyOffline: notifyOffline ?? this.notifyOffline,
      notifyStatusChange: notifyStatusChange ?? this.notifyStatusChange,
    );
  }
}

/// Provider mock de preferencias de notificación
final notificationPreferencesProvider = StateNotifierProvider<NotificationPreferencesNotifier, List<NotificationPreferences>>((ref) {
  return NotificationPreferencesNotifier();
});

class NotificationPreferencesNotifier extends StateNotifier<List<NotificationPreferences>> {
  NotificationPreferencesNotifier() : super([
    const NotificationPreferences(
      deviceId: 'vita_001',
      deviceName: 'Main Gate', // Demo device name
      notifyActions: true,
      notifyOffline: true,
      notifyStatusChange: true,
    ),
    const NotificationPreferences(
      deviceId: 'vita_002',
      deviceName: 'VITA_APO1234',
      notifyActions: false,
      notifyOffline: true,
      notifyStatusChange: false,
    ),
    const NotificationPreferences(
      deviceId: 'vita_003',
      deviceName: 'Garage Gate', // Demo device name
      notifyActions: true,
      notifyOffline: false,
      notifyStatusChange: true,
    ),
  ]);

  void updatePreferences(String deviceId, NotificationPreferences preferences) {
    state = state.map((pref) => 
      pref.deviceId == deviceId ? preferences : pref
    ).toList();
  }
}

/// Pantalla de configuración de preferencias de notificaciones
class NotificationPreferencesScreen extends ConsumerWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(notificationPreferencesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.surface,
            child: Column(
              children: [
                const SizedBox(height: 16),
                PageHeader(
                  title: AppLocalizations.of(context)!.notificationPreferences,
                  titleFontSize: 24.0,
                  showBackButton: true,
                  onBack: () => context.pop(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Descripción
          Container(
            width: double.infinity,
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              AppLocalizations.of(context)!.notificationPreferencesDescription ?? 
              'Configura qué notificaciones quieres recibir para cada dispositivo',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 16),

          // Lista de dispositivos
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: preferences.length,
              itemBuilder: (context, index) {
                final devicePrefs = preferences[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildDevicePreferencesCard(
                    context,
                    ref,
                    devicePrefs,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevicePreferencesCard(
    BuildContext context,
    WidgetRef ref,
    NotificationPreferences preferences,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del dispositivo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.deviceHeader,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.devices,
                    color: AppColors.primaryPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        preferences.deviceName,
                        style: AppTextStyles.cardTitle,
                      ),
                      Text(
                        preferences.deviceId,
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Opciones de notificación
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.notificationTypes ?? 'Tipos de notificación',
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: 16),

                // Notificar acciones
                _buildPreferenceOption(
                  context: context,
                  icon: Icons.lock_open,
                  iconColor: AppColors.success,
                  title: AppLocalizations.of(context)!.notifyActions,
                  subtitle: AppLocalizations.of(context)!.notifyActionsDescription ?? 
                           'Cuando alguien opera el dispositivo',
                  value: preferences.notifyActions,
                  onChanged: (value) {
                    ref.read(notificationPreferencesProvider.notifier).updatePreferences(
                      preferences.deviceId,
                      preferences.copyWith(notifyActions: value),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Notificar desconexión
                _buildPreferenceOption(
                  context: context,
                  icon: Icons.wifi_off,
                  iconColor: AppColors.error,
                  title: AppLocalizations.of(context)!.notifyOffline,
                  subtitle: AppLocalizations.of(context)!.notifyOfflineDescription ?? 
                           'Cuando el dispositivo se desconecta',
                  value: preferences.notifyOffline,
                  onChanged: (value) {
                    ref.read(notificationPreferencesProvider.notifier).updatePreferences(
                      preferences.deviceId,
                      preferences.copyWith(notifyOffline: value),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Notificar cambios de estado
                _buildPreferenceOption(
                  context: context,
                  icon: Icons.info,
                  iconColor: AppColors.warning,
                  title: AppLocalizations.of(context)!.notifyStatusChange,
                  subtitle: AppLocalizations.of(context)!.notifyStatusChangeDescription ?? 
                           'Cuando cambia el estado del motor',
                  value: preferences.notifyStatusChange,
                  onChanged: (value) {
                    ref.read(notificationPreferencesProvider.notifier).updatePreferences(
                      preferences.deviceId,
                      preferences.copyWith(notifyStatusChange: value),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceOption({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        // Icono
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),

        // Textos
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),

        // Switch
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryPurple,
        ),
      ],
    );
  }
}