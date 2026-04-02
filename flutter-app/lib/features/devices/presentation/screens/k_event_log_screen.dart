import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/snackbar_helper.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../providers/event_log_provider.dart';
import '../widgets/event_log_item.dart';

/// Pantalla de Registro de Eventos (Pantalla K)
class EventLogScreen extends ConsumerStatefulWidget {
  const EventLogScreen({super.key});

  @override
  ConsumerState<EventLogScreen> createState() => _EventLogScreenState();
}

class _EventLogScreenState extends ConsumerState<EventLogScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _downloadLogs(int count) {
    final l10n = AppLocalizations.of(context)!;
    SnackbarHelper.showSuccess(
      context,
      l10n.eventLogDownloading(count),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final eventsAsyncValue = ref.watch(eventLogProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Header
            PageHeader(
              title: l10n.eventLogTitle,
              titleFontSize: 24,
              showBackButton: true,
            ),
            const SizedBox(height: 16),

            // Contenido principal
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Panel de Eventos (con borde y sombra)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFBDBDBD),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: eventsAsyncValue.when(
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (error, stack) => Center(
                            child: Text('Error: $error'),
                          ),
                          data: (events) {
                            if (events.isEmpty) {
                              return Center(
                                child: Text(l10n.eventLogEmpty),
                              );
                            }

                            return Scrollbar(
                              controller: _scrollController,
                              thumbVisibility: true,
                              thickness: 8,
                              radius: const Radius.circular(4),
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: events.length,
                                itemBuilder: (context, index) {
                                  return EventLogItem(event: events[index]);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Botón Descargar Registros
                    eventsAsyncValue.maybeWhen(
                      data: (events) => CustomButton(
                        text: l10n.eventLogDownload,
                        onPressed: events.isNotEmpty
                            ? () => _downloadLogs(events.length)
                            : null,
                        type: ButtonType.primary,
                        icon: Icons.download,
                        height: 52,
                      ),
                      orElse: () => const SizedBox(height: 52),
                    ),
                    const SizedBox(height: 24),
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
