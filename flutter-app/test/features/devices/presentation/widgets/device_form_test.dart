import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bgnius_vita/features/devices/presentation/widgets/device_form.dart';
import 'package:bgnius_vita/shared/widgets/custom_text_field.dart';

void main() {
  Widget createWidgetUnderTest({Future<void> Function(Map<String, dynamic>)? onSave}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: DeviceForm(
          onSave: onSave ?? (_) async {},
        ),
      ),
    );
  }

  testWidgets('DeviceForm renders all sections', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Basic Info
    expect(find.text('Basic Information'), findsOneWidget); 
    expect(find.text('Name *'), findsOneWidget);

    // Identification
    expect(find.text('Identification'), findsOneWidget);
    
    // Config Section (Expandable)
    expect(find.text('Operational Config (Optional)'), findsOneWidget);
    
    // Buttons
    expect(find.text('Create Device'), findsOneWidget);
  });

  testWidgets('DeviceForm shows validation errors when empty', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Tap Save
    await tester.tap(find.text('Create Device'));
    await tester.pumpAndSettle();

    expect(find.text('Please complete all required fields'), findsOneWidget);
  });
  
  testWidgets('DeviceForm submits data when valid', (WidgetTester tester) async {
    bool saveCalled = false;
    Map<String, dynamic>? savedData;

    await tester.pumpWidget(createWidgetUnderTest(
      onSave: (data) async {
        saveCalled = true;
        savedData = data;
      },
    ));

    // Helper to find input by key
    Finder findInput(String key) {
      return find.descendant(
        of: find.byKey(Key(key)),
        matching: find.byType(TextFormField),
      );
    }

    // Fill Basic Info
    await tester.enterText(findInput('input_name'), 'Test Device');
    await tester.enterText(findInput('input_description'), 'Test Description');

    // Select Location (Dropdown)
    await tester.tap(find.text('Select Location')); 
    await tester.pumpAndSettle();
    await tester.tap(find.text('Entrada Principal').last); 
    await tester.pumpAndSettle();
    
    // Fill Identification
    await tester.enterText(findInput('input_serial'), 'SN123456');
    await tester.enterText(findInput('input_mac'), 'AA:BB:CC:DD:EE:FF');
    
    // Select Model (Dropdown)
    await tester.tap(find.text('Select Model'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('FAC 500-900 VITA').last);
    await tester.pumpAndSettle();

    // Tap Save
    await tester.scrollUntilVisible(find.text('Create Device'), 100);
    await tester.tap(find.text('Create Device'));
    await tester.pump(); // Start animation
    await tester.pump(const Duration(milliseconds: 500)); // Wait for async operation

    expect(saveCalled, isTrue);
    expect(savedData, isNotNull);
    expect(savedData!['name'], 'Test Device');
    expect(savedData!['model'], 'FAC 500-900 VITA');
  });
}
