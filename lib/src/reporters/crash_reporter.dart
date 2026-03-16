import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/crash_report.dart';
import '../models/crash_config.dart';

/// 崩溃上报器
///
/// 负责将崩溃报告上报到远程服务器。
///
/// ## 功能
///
/// - 通过 HTTP POST 上报单个崩溃
/// - 批量上报多个崩溃
/// - 自动超时控制
/// - 错误处理和重试
///
/// ## 上报格式
///
/// 崩溃报告以 JSON 格式通过 HTTP POST 发送到配置的 URL。
///
/// ```json
/// {
///   "id": "1709914800000",
///   "error": "Exception: Something went wrong",
///   "stackTrace": "...",
///   "timestamp": "2026-03-16T12:00:00.000Z",
///   "appVersion": "1.0.0",
///   "buildNumber": "1",
///   "deviceInfo": {...},
///   "appState": {...},
///   "userId": "user_123",
///   "isReported": false
/// }
/// ```
///
/// ## 内部使用
///
/// 通常不需要直接使用此类，而是通过 [CrashReporterKit] 的 API 使用。
///
/// ## 示例
///
/// ```dart
/// // 通过 CrashReporterKit 自动上报
/// await CrashReporterKit.init(
///   reportUrl: 'https://crash.example.com/api/report',
///   autoReport: true,
/// );
/// ```
class CrashReporter {
  CrashReporter(this.config);

  final CrashConfig config;

  /// 上报崩溃
  Future<bool> report(CrashReport crash) async {
    if (config.reportUrl == null) return false;

    try {
      final response = await http
          .post(
            Uri.parse(config.reportUrl!),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(crash.toJson()),
          )
          .timeout(config.reportTimeout);

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      debugPrint('Failed to report crash: $e');
      return false;
    }
  }

  /// 批量上报崩溃
  Future<int> reportBatch(List<CrashReport> crashes) async {
    if (config.reportUrl == null) return 0;

    int successCount = 0;

    for (final crash in crashes) {
      if (await report(crash)) {
        successCount++;
      }
    }

    return successCount;
  }
}
