import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dartz/dartz.dart';
import 'package:bgnius_vita/features/groups/domain/repositories/groups_repository.dart';
import 'package:bgnius_vita/features/groups/domain/entities/device_group.dart';
import 'package:bgnius_vita/features/devices/domain/entities/device.dart';
import 'package:bgnius_vita/features/groups/presentation/screens/e_groups_screen.dart';
import 'package:bgnius_vita/features/groups/presentation/providers/groups_providers.dart';
import 'package:bgnius_vita/core/errors/failures.dart';

// 1. Mock Exitoso (Happy Path)
class MockGroupsRepository implements GroupsRepository {
  @override
  Future<Either<Failure, List<DeviceGroup>>> getGroups() async {
    return Right([
      DeviceGroup(
          id: 'group_todos',
          name: 'TODOS',
          deviceIds: ['d1'],
          createdAt: DateTime.now()),
      DeviceGroup(
          id: '2', name: 'Oficina', deviceIds: [], createdAt: DateTime.now()),
    ]);
  }

  @override
  Future<Either<Failure, List<Device>>> getDevices() async {
    return Right([
      Device(
          id: 'd1',
          name: 'Puerta Principal',
          type: DeviceType.gate,
          status: DeviceStatus.ready,
          model: 'Model X',
          serialNumber: 'SN1',
          createdAt: DateTime.now()),
      Device(
          id: 'd2',
          name: 'Garaje',
          type: DeviceType.gate,
          status: DeviceStatus.ready,
          model: 'Model Y',
          serialNumber: 'SN2',
          createdAt: DateTime.now()),
    ]);
  }

  @override
  Future<Either<Failure, DeviceGroup>> addDeviceToGroup(
      String groupId, String deviceId) async {
    return Right(DeviceGroup(
        id: groupId,
        name: 'Oficina',
        description: 'desc',
        deviceIds: [deviceId],
        createdAt: DateTime.now()));
  }

  @override
  Future<Either<Failure, DeviceGroup>> createGroup(
      String name, String description) async {
    return Right(DeviceGroup(
        id: '3', name: name, deviceIds: [], createdAt: DateTime.now()));
  }

  @override
  Future<Either<Failure, DeviceGroup>> updateGroup(
      String groupId, String name, String description) async {
    return Right(DeviceGroup(
        id: groupId,
        name: name,
        description: description,
        deviceIds: [],
        createdAt: DateTime.now()));
  }

  @override
  Future<Either<Failure, void>> deleteGroup(String groupId) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, DeviceGroup>> removeDeviceFromGroup(
      String groupId, String deviceId) async {
    return Right(DeviceGroup(
        id: groupId,
        name: 'Oficina',
        deviceIds: [],
        createdAt: DateTime.now()));
  }
}

// 2. Mock Fallido (Error Path)
class MockFailingGroupsRepository implements GroupsRepository {
  @override
  Future<Either<Failure, List<DeviceGroup>>> getGroups() async {
    return const Left(
        ServerFailure('Error crítico al conectar con el servidor'));
  }

  @override
  Future<Either<Failure, List<Device>>> getDevices() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, DeviceGroup>> addDeviceToGroup(
      String groupId, String deviceId) async {
    return const Left(ServerFailure('No se pudo agregar'));
  }

  @override
  Future<Either<Failure, DeviceGroup>> createGroup(
      String name, String description) async {
    return const Left(ServerFailure('No se pudo crear'));
  }

  @override
  Future<Either<Failure, DeviceGroup>> updateGroup(
      String groupId, String name, String description) async {
    return const Left(ServerFailure('No se pudo actualizar'));
  }

  @override
  Future<Either<Failure, void>> deleteGroup(String groupId) async {
    return const Left(ServerFailure('No se pudo eliminar'));
  }

  @override
  Future<Either<Failure, DeviceGroup>> removeDeviceFromGroup(
      String groupId, String deviceId) async {
    return const Left(ServerFailure('No se pudo quitar'));
  }
}

void main() {
  testWidgets('GroupsScreen loads and displays groups (Happy Path)',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          groupsRepositoryProvider.overrideWithValue(MockGroupsRepository()),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('es'),
          home: GroupsScreen(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('TODOS'), findsOneWidget);
    expect(find.text('Oficina'), findsOneWidget);
    expect(find.text('Puerta Principal'), findsOneWidget);
  });

  testWidgets('Selecting empty group shows empty state message',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          groupsRepositoryProvider.overrideWithValue(MockGroupsRepository()),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('es'),
          home: GroupsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Oficina'));
    await tester.pumpAndSettle();

    expect(find.text('Puerta Principal'), findsNothing);
    expect(find.text('No hay dispositivos en este grupo'), findsOneWidget);
  });

  testWidgets('Shows error UI when repository fails (Error Path)',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          groupsRepositoryProvider
              .overrideWithValue(MockFailingGroupsRepository()),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('es'),
          home: GroupsScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(
        find.text('Error crítico al conectar con el servidor'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Reintentar'), findsOneWidget);
  });
}
