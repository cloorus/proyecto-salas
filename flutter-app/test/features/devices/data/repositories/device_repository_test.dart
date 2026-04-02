import 'package:flutter_test/flutter_test.dart';
import 'package:bgnius_vita/features/devices/data/repositories/device_repository_impl.dart';
import 'package:bgnius_vita/features/devices/domain/entities/device_info.dart';

void main() {
  late DeviceRepositoryImpl repository;

  setUp(() {
    repository = DeviceRepositoryImpl();
  });

  group('DeviceRepositoryImpl', () {
    test('getDeviceInfo returns valid DeviceInfo', () async {
      final result = await repository.getDeviceInfo('any-id');
      
      expect(result, isA<DeviceInfo>());
      expect(result.serialNumber, '999999i');
      expect(result.name, 'Puerta Principal');
      expect(result.groupName, 'Casa');
      expect(result.isFavorite, true);
    });

    test('getDeviceInfo returns correct id', () async {
      const testId = 'test-device-123';
      final result = await repository.getDeviceInfo(testId);
      
      expect(result.id, testId);
    });
  });
}
