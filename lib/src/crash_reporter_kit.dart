import 'dart:async';
import 'package:flutter/foundation.dart';
import 'models/crash_report.dart';
import 'models/crash_config.dart';
import 'handlers/crash_handler.dart';
import 'storage/crash_storage.dart';
import 'reporters/crash_reporter.dart';

/// CrashReporterKit - 全局崩溃报告管理器
class CrashReporterKit {
  static CrashHandler? _handler;
  static CrashConfig? _config;

  /// 初始化CrashReporterKit
  static Future<void> init({
    bool enabled = true,
    bool autoReport = true,
    String? reportUrl,
    bool collectDeviceInfo = true,
    bool collectAppState = true,
    int maxStoredCrashes = 10,
    Duration reportTimeout = const Duration(seconds: 30),
    bool enableInDebug = false,
    String? userId,
    String? appVersion,
    String? buildNumber,
  }) async {
    _config = CrashConfig(
      enabled: enabled,
      autoReport: autoReport,
      reportUrl: reportUrl,
      collectDeviceInfo: collectDeviceInfo,
      collectAppState: collectAppState,
      maxStoredCrashes: maxStoredCrashes,
      reportTimeout: reportTimeout,
      enableInDebug: enableInDebug,
      userId: userId,
      appVersion: appVersion,
      buildNumber: buildNumber,
    );

    final storage = CrashStorage();
    await storage.initialize();

    final reporter = CrashReporter(_config!);

    _handler = CrashHandler(
      config: _config!,
      storage: storage,
      reporter: reporter,
    );

    await _handler!.initialize();
  }

  /// 手动报告崩溃
  static Future<void> reportCrash({
    required Object error,
    StackTrace? stackTrace,
    Map<String, dynamic>? appState,
  }) async {
    if (_handler == null) {
      debugPrint('CrashReporterKit not initialized');
      return;
    }

    await _handler!.reportCrash(
      error: error,
      stackTrace: stackTrace,
      appState: appState,
    );
  }

  /// 获取所有崩溃报告
  static Future<List<CrashReport>> getAllCrashes() async {
    if (_handler == null) {
      debugPrint('CrashReporterKit not initialized');
      return [];
    }

    return await _handler!.getAllCrashes();
  }

  /// 清除所有崩溃报告
  static Future<void> clearAllCrashes() async {
    if (_handler == null) {
      debugPrint('CrashReporterKit not initialized');
      return;
    }

    await _handler!.clearAllCrashes();
  }

  /// 运行受保护的代码
  static Future<T?> runProtected<T>(
    Future<T> Function() callback, {
    String? context,
  }) async {
    try {
      return await callback();
    } catch (e, stack) {
      await reportCrash(
        error: e,
        stackTrace: stack,
        appState: context != null ? {'context': context} : null,
      );
      return null;
    }
  }

  /// 运行受保护的Zone
  static void runZonedGuarded(
    void Function() body, {
    void Function(Object error, StackTrace stack)? onError,
  }) {
    runZoned(
      body,
      zoneSpecification: ZoneSpecification(
        handleUncaughtError: (self, parent, zone, error, stackTrace) {
          reportCrash(error: error, stackTrace: stackTrace);
          onError?.call(error, stackTrace);
        },
      ),
    );
  }

  /// 关闭CrashReporterKit
  static void dispose() {
    _handler?.dispose();
    _handler = null;
    _config = null;
  }
}
