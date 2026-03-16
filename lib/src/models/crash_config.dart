/// 崩溃报告配置类
///
/// 用于配置 CrashReporterKit 的行为。
///
/// ## 配置选项
///
/// - [enabled]: 是否启用崩溃报告（默认：true）
/// - [autoReport]: 是否自动上报崩溃（默认：true）
/// - [reportUrl]: 远程上报的 URL（默认：null）
/// - [collectDeviceInfo]: 是否收集设备信息（默认：true）
/// - [collectAppState]: 是否收集应用状态（默认：true）
/// - [maxStoredCrashes]: 最多存储的崩溃数量（默认：10）
/// - [reportTimeout]: 上报超时时间（默认：30 秒）
/// - [enableInDebug]: 是否在调试模式启用（默认：false）
/// - [userId]: 用户 ID（可选）
/// - [appVersion]: 应用版本号（可选）
/// - [buildNumber]: 构建号（可选）
///
/// ## 使用示例
///
/// ```dart
/// final config = CrashConfig(
///   enabled: true,
///   autoReport: true,
///   reportUrl: 'https://crash.example.com/api/report',
///   collectDeviceInfo: true,
///   collectAppState: true,
///   maxStoredCrashes: 20,
///   reportTimeout: Duration(seconds: 60),
///   enableInDebug: false,
///   userId: 'user_123',
///   appVersion: '1.0.0',
///   buildNumber: '1',
/// );
/// ```
class CrashConfig {
  const CrashConfig({
    this.enabled = true,
    this.autoReport = true,
    this.reportUrl,
    this.collectDeviceInfo = true,
    this.collectAppState = true,
    this.maxStoredCrashes = 10,
    this.reportTimeout = const Duration(seconds: 30),
    this.enableInDebug = false,
    this.userId,
    this.appVersion,
    this.buildNumber,
  });

  /// 是否启用崩溃报告
  final bool enabled;

  /// 是否自动上报
  final bool autoReport;

  /// 上报URL
  final String? reportUrl;

  /// 是否收集设备信息
  final bool collectDeviceInfo;

  /// 是否收集应用状态
  final bool collectAppState;

  /// 最大存储崩溃数量
  final int maxStoredCrashes;

  /// 上报超时时间
  final Duration reportTimeout;

  /// 是否在调试模式下启用
  final bool enableInDebug;

  /// 用户ID（可选）
  final String? userId;

  /// 应用版本
  final String? appVersion;

  /// 构建号
  final String? buildNumber;

  /// 复制并修改配置
  CrashConfig copyWith({
    bool? enabled,
    bool? autoReport,
    String? reportUrl,
    bool? collectDeviceInfo,
    bool? collectAppState,
    int? maxStoredCrashes,
    Duration? reportTimeout,
    bool? enableInDebug,
    String? userId,
    String? appVersion,
    String? buildNumber,
  }) {
    return CrashConfig(
      enabled: enabled ?? this.enabled,
      autoReport: autoReport ?? this.autoReport,
      reportUrl: reportUrl ?? this.reportUrl,
      collectDeviceInfo: collectDeviceInfo ?? this.collectDeviceInfo,
      collectAppState: collectAppState ?? this.collectAppState,
      maxStoredCrashes: maxStoredCrashes ?? this.maxStoredCrashes,
      reportTimeout: reportTimeout ?? this.reportTimeout,
      enableInDebug: enableInDebug ?? this.enableInDebug,
      userId: userId ?? this.userId,
      appVersion: appVersion ?? this.appVersion,
      buildNumber: buildNumber ?? this.buildNumber,
    );
  }
}
