import 'dart:io';
import 'package:flutter/foundation.dart';

/// 崩溃报告
class CrashReport {
  CrashReport({
    required this.id,
    required this.error,
    required this.deviceInfo,
    this.stackTrace,
    DateTime? timestamp,
    this.appVersion,
    this.buildNumber,
    this.appState,
    this.userId,
    this.isReported = false,
  }) : timestamp = timestamp ?? DateTime.now();

  /// 从JSON创建
  factory CrashReport.fromJson(Map<String, dynamic> json) {
    return CrashReport(
      id: json['id'] as String,
      error: json['error'] as String,
      stackTrace: json['stackTrace'] != null
          ? StackTrace.fromString(json['stackTrace'] as String)
          : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
      appVersion: json['appVersion'] as String?,
      buildNumber: json['buildNumber'] as String?,
      deviceInfo:
          DeviceInfo.fromJson(json['deviceInfo'] as Map<String, dynamic>),
      appState: json['appState'] as Map<String, dynamic>?,
      userId: json['userId'] as String?,
      isReported: json['isReported'] as bool? ?? false,
    );
  }

  /// 唯一标识
  final String id;

  /// 错误对象
  final Object error;

  /// 堆栈跟踪
  final StackTrace? stackTrace;

  /// 时间戳
  final DateTime timestamp;

  /// 应用版本
  final String? appVersion;

  /// 构建号
  final String? buildNumber;

  /// 设备信息
  final DeviceInfo deviceInfo;

  /// 应用状态
  final Map<String, dynamic>? appState;

  /// 用户ID（可选）
  final String? userId;

  /// 是否已上报
  final bool isReported;

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'error': error.toString(),
      'stackTrace': stackTrace?.toString(),
      'timestamp': timestamp.toIso8601String(),
      'appVersion': appVersion,
      'buildNumber': buildNumber,
      'deviceInfo': deviceInfo.toJson(),
      'appState': appState,
      'userId': userId,
      'isReported': isReported,
    };
  }

  /// 复制并修改
  CrashReport copyWith({
    bool? isReported,
  }) {
    return CrashReport(
      id: id,
      error: error,
      stackTrace: stackTrace,
      timestamp: timestamp,
      appVersion: appVersion,
      buildNumber: buildNumber,
      deviceInfo: deviceInfo,
      appState: appState,
      userId: userId,
      isReported: isReported ?? this.isReported,
    );
  }

  @override
  String toString() {
    return 'CrashReport(id: $id, error: $error, timestamp: $timestamp)';
  }
}

/// 设备信息
class DeviceInfo {
  DeviceInfo({
    required this.os,
    required this.osVersion,
    this.model,
    this.brand,
    this.isPhysicalDevice = true,
    this.screenSize,
    this.memory,
  });

  /// 从JSON创建
  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      os: json['os'] as String,
      osVersion: json['osVersion'] as String,
      model: json['model'] as String?,
      brand: json['brand'] as String?,
      isPhysicalDevice: json['isPhysicalDevice'] as bool? ?? true,
      screenSize: json['screenSize'] as String?,
      memory: json['memory'] as String?,
    );
  }

  /// 操作系统
  final String os;

  /// 操作系统版本
  final String osVersion;

  /// 设备型号
  final String? model;

  /// 设备品牌
  final String? brand;

  /// 是否是物理设备
  final bool isPhysicalDevice;

  /// 屏幕尺寸
  final String? screenSize;

  /// 内存大小
  final String? memory;

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'os': os,
      'osVersion': osVersion,
      'model': model,
      'brand': brand,
      'isPhysicalDevice': isPhysicalDevice,
      'screenSize': screenSize,
      'memory': memory,
    };
  }

  /// 获取当前设备信息
  static Future<DeviceInfo> current() async {
    String os;
    String osVersion;

    if (kIsWeb) {
      os = 'Web';
      osVersion = 'Unknown';
    } else if (Platform.isAndroid) {
      os = 'Android';
      osVersion = Platform.operatingSystemVersion;
    } else if (Platform.isIOS) {
      os = 'iOS';
      osVersion = Platform.operatingSystemVersion;
    } else if (Platform.isWindows) {
      os = 'Windows';
      osVersion = Platform.operatingSystemVersion;
    } else if (Platform.isLinux) {
      os = 'Linux';
      osVersion = Platform.operatingSystemVersion;
    } else if (Platform.isMacOS) {
      os = 'macOS';
      osVersion = Platform.operatingSystemVersion;
    } else {
      os = 'Unknown';
      osVersion = 'Unknown';
    }

    return DeviceInfo(
      os: os,
      osVersion: osVersion,
      isPhysicalDevice: !kIsWeb,
    );
  }

  @override
  String toString() {
    return 'DeviceInfo(os: $os, version: $osVersion, model: $model)';
  }
}
