/// 崩溃报告配置
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
