import 'package:equatable/equatable.dart';

class EventLog extends Equatable {
  final String entity;
  final String action;
  final DateTime timestamp;

  const EventLog({
    required this.entity,
    required this.action,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [entity, action, timestamp];
}
