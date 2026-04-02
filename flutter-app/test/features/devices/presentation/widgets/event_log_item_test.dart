import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bgnius_vita/features/devices/presentation/widgets/event_log_item.dart';
import 'package:bgnius_vita/features/devices/domain/entities/event_log.dart';

void main() {
  testWidgets('EventLogItem displays correct information', (WidgetTester tester) async {
    // Arrange
    final testEvent = EventLog(
      entity: 'Test User',
      action: 'Test Action',
      timestamp: DateTime(2024, 1, 1, 12, 30),
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventLogItem(event: testEvent),
        ),
      ),
    );

    // Assert
    // Check if the text matches "Entity | Action | Date" format
    // DateFormat('dd/MM/yy HH:mm') -> 01/01/24 12:30
    
    final expectedText = 'Test User | Test Action | 01/01/24 12:30';
    expect(find.text(expectedText), findsOneWidget);
  });
}
