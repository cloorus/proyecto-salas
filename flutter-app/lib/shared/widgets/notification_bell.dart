import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../features/notifications/presentation/providers/notifications_provider.dart';

/// Widget de campana de notificaciones con badge de conteo no leídas
/// 
/// Se puede usar como FloatingActionButton, en AppBar actions, o como widget independiente
class NotificationBell extends ConsumerWidget {
  final VoidCallback? onPressed;
  final double size;
  final Color? iconColor;
  final Color? badgeColor;

  const NotificationBell({
    super.key,
    this.onPressed,
    this.size = 24.0,
    this.iconColor,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsState = ref.watch(notificationsProvider);
    final unreadCount = notificationsState.unreadCount;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            size: size,
            color: iconColor ?? AppColors.titleBlue,
          ),
          onPressed: onPressed ?? () => context.push('/notifications'),
          tooltip: AppLocalizations.of(context)!.notificationTooltip,
        ),
        
        // Badge de conteo no leído
        if (unreadCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: badgeColor ?? AppColors.error,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                unreadCount > 99 ? '99+' : unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

/// FloatingActionButton específico para notificaciones
class NotificationFloatingButton extends ConsumerWidget {
  const NotificationFloatingButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsState = ref.watch(notificationsProvider);
    final unreadCount = notificationsState.unreadCount;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        FloatingActionButton(
          onPressed: () => context.push('/notifications'),
          backgroundColor: AppColors.primaryPurple,
          child: const Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 28,
          ),
        ),
        
        // Badge de conteo no leído
        if (unreadCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Text(
                unreadCount > 99 ? '99+' : unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}