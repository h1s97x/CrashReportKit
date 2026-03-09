import 'package:flutter_test/flutter_test.dart';
import 'package:crash_reporter_kit/crash_reporter_kit.dart';

void main() {
  test('CrashReport serialization', () {
    final deviceInfo = DeviceInfo(
      os: 'Android',
      osVersion: '13',
      model: 'Pixel 7',
      brand: 'Google',
      isPhysicalDevice: true,
    );

    final report = CrashReport(
      id: '123',
      error: Exception('Test error'),
      stackTrace: StackTrace.current,
      deviceInfo: deviceInfo,
      appVersion: '1.0.0',
      buildNumber: '1',
    );

    final json = report.toJson();
    expect(json['id'], '123');
    expect(json['appVersion'], '1.0.0');
    expect(json['deviceInfo']['os'], 'Android');
  });
}
