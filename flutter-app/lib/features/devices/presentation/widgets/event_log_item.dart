import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/event_log.dart';

class EventLogItem extends StatelessWidget {
  final EventLog event;

  const EventLogItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('dd/MM/yy HH:mm').format(event.timestamp);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
        right: 16,
      ),
      child: Text(
        '${event.entity} | ${event.action} | $formattedDate',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
    );
  }
}
