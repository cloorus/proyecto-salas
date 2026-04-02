import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/page_header.dart';
import '../providers/notifications_provider.dart';
import '../../domain/entities/app_notification.dart';

/// Pantalla de notificaciones
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Refrescar notificaciones al entrar a la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationsProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificationsState = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header con título y acción
          Container(
            color: AppColors.surface,
            child: Column(
              children: [
                const SizedBox(height: 16),
                PageHeader(
                  title: AppLocalizations.of(context)!.notificationsTitle,
                  titleFontSize: 24.0,
                  showBackButton: true,
                  onBack: () => context.pop(),
                ),
                // Botón "Marcar todas como leídas"
                if (notificationsState.unreadCount > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            ref.read(notificationsProvider.notifier).markAllAsRead();
                          },
                          icon: const Icon(
                            Icons.done_all,
                            size: 18,
                            color: AppColors.primaryPurple,
                          ),
                          label: Text(
                            AppLocalizations.of(context)!.markAllAsRead,
                            style: AppTextStyles.linkSecondary.copyWith(
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Lista de notificaciones
          Expanded(
            child: _buildNotificationsList(notificationsState),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(NotificationsState state) {
    if (state.isLoading && state.notifications.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryPurple,
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar notificaciones',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.error!,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(notificationsProvider.notifier).refresh();
              },
              child: Text(AppLocalizations.of(context)!.retry ?? 'Reintentar'),
            ),
          ],
        ),
      );
    }

    if (state.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noNotifications,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primaryPurple,
      onRefresh: () => ref.read(notificationsProvider.notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: state.notifications.length,
        itemBuilder: (context, index) {
          final notification = state.notifications[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildNotificationCard(notification),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: AppColors.success,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(
          Icons.done,
          color: Colors.white,
          size: 24,
        ),
      ),
      onDismissed: (direction) {
        if (!notification.isRead) {
          ref.read(notificationsProvider.notifier).markAsRead(notification.id);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: notification.isRead
              ? AppColors.surface
              : AppColors.primaryPurple.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: _getNotificationTypeColor(notification.type),
              width: 4,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (!notification.isRead) {
                ref.read(notificationsProvider.notifier).markAsRead(notification.id);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icono por tipo
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getNotificationTypeColor(notification.type).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getNotificationTypeIcon(notification.type),
                      color: _getNotificationTypeColor(notification.type),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Contenido
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título
                        Text(
                          notification.title,
                          style: AppTextStyles.cardTitle.copyWith(
                            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Cuerpo
                        Text(
                          notification.body,
                          style: AppTextStyles.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        // Dispositivo (si existe)
                        if (notification.deviceName != null)
                          Row(
                            children: [
                              Icon(
                                Icons.devices,
                                size: 12,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                notification.deviceName!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  // Tiempo y estado
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatTimeAgo(notification.createdAt),
                        style: AppTextStyles.bodySmall,
                      ),
                      if (!notification.isRead) ...[
                        const SizedBox(height: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryPurple,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getNotificationTypeIcon(String type) {
    switch (type) {
      case AppNotification.actionExecuted:
        return Icons.lock_open;
      case AppNotification.deviceOffline:
        return Icons.wifi_off;
      case AppNotification.deviceOnline:
        return Icons.wifi;
      case AppNotification.statusChange:
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationTypeColor(String type) {
    switch (type) {
      case AppNotification.actionExecuted:
        return AppColors.success;
      case AppNotification.deviceOffline:
        return AppColors.error;
      case AppNotification.deviceOnline:
        return AppColors.success;
      case AppNotification.statusChange:
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return AppLocalizations.of(context)!.justNow ?? 'Ahora';
    } else if (difference.inMinutes < 60) {
      return AppLocalizations.of(context)!.minutesAgo(difference.inMinutes.toString());
    } else if (difference.inHours < 24) {
      return AppLocalizations.of(context)!.hoursAgo(difference.inHours.toString());
    } else {
      return AppLocalizations.of(context)!.daysAgo(difference.inDays.toString()) ??
             '${difference.inDays}d';
    }
  }
}