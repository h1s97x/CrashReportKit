import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/crash_report.dart';
import '../models/crash_config.dart';

/// 崩溃上报器
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
