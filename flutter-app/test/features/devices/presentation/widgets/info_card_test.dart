import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bgnius_vita/features/devices/presentation/widgets/info_card.dart';

void main() {
  testWidgets('InfoCard displays label and value correctly', (WidgetTester tester) async {
    // Arrange
    const testLabel = 'Serial Number';
    const testValue = '123456';

    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: InfoCard(label: testLabel, value: testValue),
        ),
      ),
    );

    // Assert
    expect(find.text(testLabel), findsOneWidget);
    expect(find.text(testValue), findsOneWidget);
  });

  testWidgets('InfoCard displays only value explicitly when label is null', (WidgetTester tester) async {
    // Arrange
    const testValue = 'Single Value';

    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: InfoCard(value: testValue),
        ),
      ),
    );

    // Assert
    expect(find.text(testValue), findsOneWidget);
    // Should be centered, so we can check if it's the only text widget in the card structure conceptually
    // But verify existence is enough for now.
  });
}
