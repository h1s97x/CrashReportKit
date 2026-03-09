import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/crash_report.dart';
import '../models/crash_config.dart';
import '../storage/crash_storage.dart';
import '../reporters/crash_reporter.dart';

/// 崩溃处理器
class CrashHandler {
  CrashHandler({
    required this.config,
    required this.storage,
    required this.reporter,
  });

  final CrashConfig config;
  final CrashStorage storage;
  final CrashReporter reporter;

  FlutterExceptionHandler? _originalOnError;
  ErrorCallback? _originalOnPlatformError;

  /// 初始化崩溃处理
  Future<void> initialize() async {
    if (!config.enabled) return;
    if (!config.enableInDebug && kDebugMode) return;

    // 捕获Flutter错误
    _originalOnError = FlutterError.onError;
    FlutterError.onError = _handleFlutterError;

    // 捕获异步错误
    _originalOnPlatformError = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = _handlePlatformError;

    // 上报未上报的崩溃
    if (config.autoReport) {
      await _reportStoredCrashes();
    }
  }

  /// 处理Flutter错误
  void _handleFlutterError(FlutterErrorDetails details) {
    // 调用原始处理器
    _originalOnError?.call(details);

    // 记录崩溃
    _recordCrash(
      error: details.exception,
      stackTrace: details.stack,
      context: details.context?.toString(),
    );
  }

  /// 处理平台错误
  bool _handlePlatformError(Object error, StackTrace stack) {
    // 调用原始处理器
    final handled = _originalOnPlatformError?.call(error, stack) ?? false;

    // 记录崩溃
    _recordCrash(
      error: error,
      stackTrace: stack,
    );

    return handled;
  }

  /// 记录崩溃
  Future<void> _recordCrash({
    required Object error,
    StackTrace? stackTrace,
    String? context,
  }) async {
    try {
      final deviceInfo = await DeviceInfo.current();

      final report = CrashReport(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        error: error,
        stackTrace: stackTrace,
        deviceInfo: deviceInfo,
        appVersion: config.appVersion,
        buildNumber: config.buildNumber,
        userId: config.userId,
        appState: config.collectAppState ? _collectAppState(context) : null,
      );

      // 存储崩溃报告
      await storage.save(report);

      // 自动上报
      if (config.autoReport && config.reportUrl != null) {
        await reporter.report(report);
      }
    } catch (e) {
      // 记录崩溃失败，静默处理
      debugPrint('Failed to record crash: $e');
    }
  }

  /// 收集应用状态
  Map<String, dynamic> _collectAppState(String? context) {
    return {
      'context': context,
      'timestamp': DateTime.now().toIso8601String(),
      'debugMode': kDebugMode,
      'releaseMode': kReleaseMode,
      'profileMode': kProfileMode,
    };
  }

  /// 上报存储的崩溃
  Future<void> _reportStoredCrashes() async {
    if (config.reportUrl == null) return;

    try {
      final crashes = await storage.getAll();

      for (final crash in crashes) {
        if (!crash.isReported) {
          final success = await reporter.report(crash);
          if (success) {
            await storage.markAsReported(crash.id);
          }
        }
      }

      // 清理旧崩溃
      await storage.cleanup(config.maxStoredCrashes);
    } catch (e) {
      debugPrint('Failed to report stored crashes: $e');
    }
  }

  /// 手动报告崩溃
  Future<void> reportCrash({
    required Object error,
    StackTrace? stackTrace,
    Map<String, dynamic>? appState,
  }) async {
    await _recordCrash(
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// 获取所有崩溃报告
  Future<List<CrashReport>> getAllCrashes() async {
    return await storage.getAll();
  }

  /// 清除所有崩溃报告
  Future<void> clearAllCrashes() async {
    await storage.clear();
  }

  /// 恢复原始错误处理器
  void dispose() {
    if (_originalOnError != null) {
      FlutterError.onError = _originalOnError;
    }
    if (_originalOnPlatformError != null) {
      PlatformDispatcher.instance.onError = _originalOnPlatformError;
    }
  }
}

/// 错误回调类型
typedef ErrorCallback = bool Function(Object error, StackTrace stack);
