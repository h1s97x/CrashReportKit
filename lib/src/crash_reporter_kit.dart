import 'dart:async';
import 'package:flutter/foundation.dart';
import 'models/crash_report.dart';
import 'models/crash_config.dart';
import 'handlers/crash_handler.dart';
import 'storage/crash_storage.dart';
import 'reporters/crash_reporter.dart';

/// CrashReporterKit - 全局崩溃报告管理器
///
/// 提供统一的 API 来初始化、配置和管理崩溃报告。
///
/// ## 初始化
///
/// ```dart
/// await CrashReporterKit.init(
///   enabled: true,
///   autoReport: true,
///   reportUrl: 'https://crash.example.com/api/report',
///   enableInDebug: false,
///   userId: 'user_123',
///   appVersion: '1.0.0',
/// );
/// ```
///
/// ## 手动报告
///
/// ```dart
/// try {
///   riskyOperation();
/// } catch (e, stack) {
///   await CrashReporterKit.reportCrash(
///     error: e,
///     stackTrace: stack,
///     appState: {'screen': 'HomePage'},
///   );
/// }
/// ```
///
/// ## 受保护执行
///
/// ```dart
/// final result = await CrashReporterKit.runProtected(
///   () => api.fetchData(),
///   context: 'API call',
/// );
/// ```
///
/// ## Zone 保护
///
/// ```dart
/// CrashReporterKit.runZonedGuarded(
///   () => runApp(MyApp()),
///   onError: (error, stack) {
///     print('Caught error: $error');
///   },
/// );
/// ```
class CrashReporterKit {
  static CrashHandler? _handler;
  static CrashConfig? _config;

  /// 初始化 CrashReporterKit
  ///
  /// 必须在应用启动时调用此方法。
  ///
  /// 参数说明：
  /// - [enabled]: 是否启用崩溃报告，默认为 true
  /// - [autoReport]: 是否自动上报崩溃，默认为 true
  /// - [reportUrl]: 远程上报的 URL，为 null 时不上报
  /// - [collectDeviceInfo]: 是否收集设备信息，默认为 true
  /// - [collectAppState]: 是否收集应用状态，默认为 true
  /// - [maxStoredCrashes]: 最多存储的崩溃数量，默认为 10
  /// - [reportTimeout]: 上报超时时间，默认为 30 秒
  /// - [enableInDebug]: 是否在调试模式启用，默认为 false
  /// - [userId]: 用户 ID，用于标识用户
  /// - [appVersion]: 应用版本号
  /// - [buildNumber]: 构建号
  ///
  /// 示例：
  /// ```dart
  /// await CrashReporterKit.init(
  ///   enabled: true,
  ///   autoReport: true,
  ///   reportUrl: 'https://crash.example.com/api/report',
  ///   enableInDebug: false,
  ///   userId: 'user_123',
  ///   appVersion: '1.0.0',
  ///   buildNumber: '1',
  /// );
  /// ```
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
  ///
  /// 用于在 catch 块中手动报告捕获的异常。
  ///
  /// 参数说明：
  /// - [error]: 错误对象（必需）
  /// - [stackTrace]: 堆栈跟踪信息
  /// - [appState]: 应用状态信息，用于调试
  ///
  /// 示例：
  /// ```dart
  /// try {
  ///   await riskyOperation();
  /// } catch (e, stack) {
  ///   await CrashReporterKit.reportCrash(
  ///     error: e,
  ///     stackTrace: stack,
  ///     appState: {
  ///       'screen': 'HomePage',
  ///       'action': 'button_click',
  ///     },
  ///   );
  /// }
  /// ```
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
  ///
  /// 返回本地存储的所有崩溃报告列表。
  ///
  /// 返回值：
  /// - 返回 [CrashReport] 列表，如果没有崩溃则返回空列表
  ///
  /// 示例：
  /// ```dart
  /// final crashes = await CrashReporterKit.getAllCrashes();
  /// for (final crash in crashes) {
  ///   print('Error: ${crash.error}');
  ///   print('Time: ${crash.timestamp}');
  ///   print('Reported: ${crash.isReported}');
  /// }
  /// ```
  static Future<List<CrashReport>> getAllCrashes() async {
    if (_handler == null) {
      debugPrint('CrashReporterKit not initialized');
      return [];
    }

    return await _handler!.getAllCrashes();
  }

  /// 清除所有崩溃报告
  ///
  /// 删除本地存储的所有崩溃报告。
  ///
  /// 注意：此操作不可撤销，请谨慎使用。
  ///
  /// 示例：
  /// ```dart
  /// await CrashReporterKit.clearAllCrashes();
  /// ```
  static Future<void> clearAllCrashes() async {
    if (_handler == null) {
      debugPrint('CrashReporterKit not initialized');
      return;
    }

    await _handler!.clearAllCrashes();
  }

  /// 运行受保护的代码
  ///
  /// 执行可能抛出异常的代码，自动捕获并报告异常。
  ///
  /// 类型参数：
  /// - [T]: 回调函数的返回类型
  ///
  /// 参数说明：
  /// - [callback]: 要执行的异步函数
  /// - [context]: 上下文信息，用于调试
  ///
  /// 返回值：
  /// - 如果执行成功，返回回调函数的结果
  /// - 如果发生异常，返回 null 并自动报告异常
  ///
  /// 示例：
  /// ```dart
  /// final data = await CrashReporterKit.runProtected(
  ///   () => api.fetchData(),
  ///   context: 'Fetch user data',
  /// );
  ///
  /// if (data == null) {
  ///   print('Failed to fetch data');
  /// } else {
  ///   print('Data: $data');
  /// }
  /// ```
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

  /// 运行受保护的 Zone
  ///
  /// 在一个受保护的 Zone 中运行代码，捕获所有未捕获的异常。
  ///
  /// 参数说明：
  /// - [body]: 要在 Zone 中执行的函数
  /// - [onError]: 可选的错误处理回调
  ///
  /// 注意：
  /// - 所有未捕获的异常都会被自动报告
  /// - 如果提供了 [onError]，会在报告后调用
  /// - 应该在应用启动时调用此方法
  ///
  /// 示例：
  /// ```dart
  /// void main() {
  ///   CrashReporterKit.runZonedGuarded(
  ///     () => runApp(MyApp()),
  ///     onError: (error, stack) {
  ///       print('Uncaught error: $error');
  ///     },
  ///   );
  /// }
  /// ```
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

  /// 关闭 CrashReporterKit
  ///
  /// 释放所有资源，停止崩溃报告。
  ///
  /// 通常在应用关闭时调用。
  ///
  /// 示例：
  /// ```dart
  /// @override
  /// void dispose() {
  ///   CrashReporterKit.dispose();
  ///   super.dispose();
  /// }
  /// ```
  static void dispose() {
    _handler?.dispose();
    _handler = null;
    _config = null;
  }
}
