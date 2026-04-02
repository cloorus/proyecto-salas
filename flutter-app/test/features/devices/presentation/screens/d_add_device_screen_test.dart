import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bgnius_vita/features/devices/presentation/screens/d_add_device_screen.dart';
import 'package:bgnius_vita/features/devices/domain/repositories/device_repository.dart';
import 'package:bgnius_vita/features/devices/domain/entities/device_info.dart';
import 'package:bgnius_vita/features/devices/presentation/providers/device_info_provider.dart';
import 'package:bgnius_vita/shared/widgets/custom_text_field.dart';

// Manual Mock
class MockDeviceRepository implements DeviceRepository {
  bool createDeviceCalled = false;
  Map<String, dynamic>? capturedData;

  @override
  Future<void> createDevice(Map<String, dynamic> data) async {
    createDeviceCalled = true;
    capturedData = data;
  }

  @override
  Future<DeviceInfo> getDeviceInfo(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateDevice(DeviceInfo device) async {
    throw UnimplementedError();
  }
}

void main() {
  testWidgets('AddDeviceScreen calls createDevice on valid submission', (WidgetTester tester) async {
    final mockRepo = MockDeviceRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceRepositoryProvider.overrideWithValue(mockRepo),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AddDeviceScreen(),
        ),
      ),
    );

    // Verify Title
    // Note: AppLocalizations must be working.
    // "Add Device" in English
    expect(find.text('Add Device'), findsOneWidget); 

    // Helper to find input by key
    Finder findInput(String key) {
      return find.descendant(
        of: find.byKey(Key(key)),
        matching: find.byType(TextFormField),
      );
    }

    // Fill Form (Minimal required fields)
    await tester.scrollUntilVisible(findInput('input_name'), 100);
    await tester.enterText(findInput('input_name'), 'Integration Test Device');
    
    // Select Location
    await tester.tap(find.text('Select Location'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Entrada Principal').last); 
    await tester.pumpAndSettle();

    // Fill ID
    await tester.scrollUntilVisible(findInput('input_serial'), 100);
    await tester.enterText(findInput('input_serial'), 'SN999');
    await tester.enterText(findInput('input_mac'), 'AA:AA:AA:AA:AA:AA');

    // Select Model
    await tester.tap(find.text('Select Model'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('FAC 500-900 VITA').last);
    await tester.pumpAndSettle();

    // Submit
    await tester.scrollUntilVisible(find.text('Create Device'), 100);
    await tester.tap(find.text('Create Device'));
    await tester.pump(); // Start async action and animation
    
    // Wait for "repository" future (mocked)
    await tester.pump(const Duration(milliseconds: 100)); 

    // Verify Mock was called
    expect(mockRepo.createDeviceCalled, isTrue);
    expect(mockRepo.capturedData!['name'], 'Integration Test Device');
  });
}
