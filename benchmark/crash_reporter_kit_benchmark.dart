// ignore_for_file: avoid_print

/// Benchmark tests for crash_reporter_kit.
///
/// Run with: dart run benchmark/crash_reporter_kit_benchmark.dart
library;

import 'dart:async';
import 'package:crash_reporter_kit/crash_reporter_kit.dart';

void main() async {
  print('=== crash_reporter_kit Performance Benchmark ===\n');

  // 初始化
  await _initializeCrashReporter();

  // 运行基准测试
  await benchmarkCrashReporting();
  await benchmarkStorageOperations();
  await benchmarkDeviceInfoCollection();
  await benchmarkConcurrentReporting();
  await benchmarkRepeatedReporting();

  // 清理
  await _cleanup();

  print('\n=== Benchmark Complete ===');
}

/// 初始化崩溃报告器
Future<void> _initializeCrashReporter() async {
  await CrashReporterKit.init(
    enabled: true,
    autoReport: false, // 禁用自动上报以便测试
    collectDeviceInfo: true,
    collectAppState: true,
    maxStoredCrashes: 100,
    enableInDebug: true,
  );
}

/// 清理测试数据
Future<void> _cleanup() async {
  await CrashReporterKit.clearAllCrashes();
  CrashReporterKit.dispose();
}

/// Benchmark: 崩溃报告性能
Future<void> benchmarkCrashReporting() async {
  print('--- Crash Reporting Benchmark ---');

  const iterations = 100;
  final stopwatch = Stopwatch()..start();

  for (int i = 0; i < iterations; i++) {
    try {
      await CrashReporterKit.reportCrash(
        error: Exception('Test error $i'),
        stackTrace: StackTrace.current,
        appState: {'iteration': i, 'test': 'benchmark'},
      );
    } catch (e) {
      // 忽略错误
    }
  }

  stopwatch.stop();
  final avgTime = stopwatch.elapsedMilliseconds / iterations;
  print(
    '  Report crash: ${avgTime.toStringAsFixed(2)} ms/op ($iterations iterations)',
  );
  print('  Total time: ${stopwatch.elapsedMilliseconds} ms');
  print('');
}

/// Benchmark: 存储操作性能
Future<void> benchmarkStorageOperations() async {
  print('--- Storage Operations Benchmark ---');

  const iterations = 50;

  // 写入性能
  var stopwatch = Stopwatch()..start();
  for (int i = 0; i < iterations; i++) {
    await CrashReporterKit.reportCrash(
      error: Exception('Storage test $i'),
      stackTrace: StackTrace.current,
    );
  }
  stopwatch.stop();
  print(
    '  Write crashes: ${(stopwatch.elapsedMilliseconds / iterations).toStringAsFixed(2)} ms/op',
  );

  // 读取性能
  stopwatch = Stopwatch()..start();
  for (int i = 0; i < iterations; i++) {
    await CrashReporterKit.getAllCrashes();
  }
  stopwatch.stop();
  print(
    '  Read all crashes: ${(stopwatch.elapsedMilliseconds / iterations).toStringAsFixed(2)} ms/op',
  );

  // 清理性能
  stopwatch = Stopwatch()..start();
  await CrashReporterKit.clearAllCrashes();
  stopwatch.stop();
  print('  Clear all crashes: ${stopwatch.elapsedMilliseconds} ms');

  print('');
}

/// Benchmark: 设备信息收集性能
Future<void> benchmarkDeviceInfoCollection() async {
  print('--- Device Info Collection Benchmark ---');

  const iterations = 1000;
  final stopwatch = Stopwatch()..start();

  for (int i = 0; i < iterations; i++) {
    try {
      await DeviceInfo.current();
    } catch (e) {
      // 忽略错误
    }
  }

  stopwatch.stop();
  final avgTime = stopwatch.elapsedMilliseconds / iterations;
  print(
    '  Collect device info: ${avgTime.toStringAsFixed(3)} ms/op ($iterations iterations)',
  );
  print('');
}

/// Benchmark: 并发报告性能
Future<void> benchmarkConcurrentReporting() async {
  print('--- Concurrent Reporting Benchmark ---');

  const concurrentCalls = 20;
  final stopwatch = Stopwatch()..start();

  try {
    await Future.wait([
      for (int i = 0; i < concurrentCalls; i++)
        CrashReporterKit.reportCrash(
          error: Exception('Concurrent test $i'),
          stackTrace: StackTrace.current,
          appState: {'concurrent': true, 'index': i},
        ),
    ]);
  } catch (e) {
    // 忽略错误
  }

  stopwatch.stop();
  final avgTime = stopwatch.elapsedMilliseconds / concurrentCalls;
  print(
    '  Concurrent crash reports: ${avgTime.toStringAsFixed(2)} ms/call ($concurrentCalls concurrent)',
  );
  print('  Total time: ${stopwatch.elapsedMilliseconds} ms');
  print('');
}

/// Benchmark: 重复报告性能（测试性能稳定性）
Future<void> benchmarkRepeatedReporting() async {
  print('--- Repeated Reporting Benchmark ---');

  const iterations = 500;
  final stopwatch = Stopwatch()..start();

  for (int i = 0; i < iterations; i++) {
    try {
      await CrashReporterKit.reportCrash(
        error: Exception('Repeated test'),
        stackTrace: StackTrace.current,
      );
    } catch (e) {
      // 忽略错误
    }
  }

  stopwatch.stop();
  final avgTime = stopwatch.elapsedMilliseconds / iterations;
  print(
    '  Repeated crash reports: ${avgTime.toStringAsFixed(3)} ms/op ($iterations iterations)',
  );
  print('');
}
