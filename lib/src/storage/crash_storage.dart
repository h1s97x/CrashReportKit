import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../models/crash_report.dart';

/// 崩溃存储类
///
/// 负责本地存储和管理崩溃报告。
///
/// ## 存储位置
///
/// 崩溃报告存储在应用文档目录的 `crashes/` 文件夹中，每个崩溃报告为一个 JSON 文件。
///
/// ## 功能
///
/// - 保存崩溃报告到本地文件系统
/// - 读取和查询崩溃报告
/// - 标记崩溃为已上报
/// - 清理旧崩溃报告
/// - 删除指定的崩溃报告
///
/// ## 内部使用
///
/// 通常不需要直接使用此类，而是通过 [CrashReporterKit] 的 API 使用。
///
/// ## 示例
///
/// ```dart
/// // 通过 CrashReporterKit 自动管理
/// final crashes = await CrashReporterKit.getAllCrashes();
/// await CrashReporterKit.clearAllCrashes();
/// ```
class CrashStorage {
  static const String _crashDir = 'crashes';
  Directory? _directory;

  /// 初始化存储
  Future<void> initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    _directory = Directory(path.join(appDir.path, _crashDir));

    if (!await _directory!.exists()) {
      await _directory!.create(recursive: true);
    }
  }

  /// 保存崩溃报告
  Future<void> save(CrashReport report) async {
    await _ensureInitialized();

    final file = File(path.join(_directory!.path, '${report.id}.json'));
    await file.writeAsString(jsonEncode(report.toJson()));
  }

  /// 获取所有崩溃报告
  Future<List<CrashReport>> getAll() async {
    await _ensureInitialized();

    final files = await _directory!
        .list()
        .where((entity) => entity is File && entity.path.endsWith('.json'))
        .cast<File>()
        .toList();

    final reports = <CrashReport>[];

    for (final file in files) {
      try {
        final content = await file.readAsString();
        final json = jsonDecode(content) as Map<String, dynamic>;
        reports.add(CrashReport.fromJson(json));
      } catch (e) {
        // 忽略损坏的文件
        await file.delete();
      }
    }

    // 按时间排序
    reports.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return reports;
  }

  /// 获取单个崩溃报告
  Future<CrashReport?> get(String id) async {
    await _ensureInitialized();

    final file = File(path.join(_directory!.path, '$id.json'));

    if (!await file.exists()) return null;

    try {
      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      return CrashReport.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  /// 标记为已上报
  Future<void> markAsReported(String id) async {
    final report = await get(id);
    if (report == null) return;

    final updated = report.copyWith(isReported: true);
    await save(updated);
  }

  /// 删除崩溃报告
  Future<void> delete(String id) async {
    await _ensureInitialized();

    final file = File(path.join(_directory!.path, '$id.json'));

    if (await file.exists()) {
      await file.delete();
    }
  }

  /// 清理旧崩溃（保留最近的N个）
  Future<void> cleanup(int maxCount) async {
    final reports = await getAll();

    if (reports.length > maxCount) {
      final toDelete = reports.skip(maxCount);

      for (final report in toDelete) {
        await delete(report.id);
      }
    }
  }

  /// 清除所有崩溃报告
  Future<void> clear() async {
    await _ensureInitialized();

    final files = await _directory!
        .list()
        .where((entity) => entity is File)
        .cast<File>()
        .toList();

    for (final file in files) {
      await file.delete();
    }
  }

  /// 确保已初始化
  Future<void> _ensureInitialized() async {
    if (_directory == null) {
      await initialize();
    }
  }
}
