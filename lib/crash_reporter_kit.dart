/// CrashReporterKit - 一个功能完善的 Flutter 崩溃报告工具包
///
/// 提供自动崩溃检测、本地存储和远程上报功能。
///
/// ## 快速开始
///
/// ```dart
/// import 'package:crash_reporter_kit/crash_reporter_kit.dart';
///
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   // 初始化
///   await CrashReporterKit.init(
///     enabled: true,
///     autoReport: true,
///     reportUrl: 'https://crash.example.com/api/report',
///   );
///
///   // 使用 runZonedGuarded 捕获所有异常
///   CrashReporterKit.runZonedGuarded(
///     () => runApp(MyApp()),
///   );
/// }
/// ```
///
/// ## 主要功能
///
/// - 自动崩溃检测和上报
/// - 本地崩溃存储
/// - 设备信息收集
/// - 应用状态记录
/// - 受保护的代码执行
/// - 崩溃报告管理
///
/// ## 相关类
///
/// - [CrashReporterKit] - 全局管理器
/// - [CrashReport] - 崩溃报告模型
/// - [CrashConfig] - 配置类
/// - [CrashHandler] - 崩溃处理器
/// - [CrashStorage] - 本地存储
/// - [CrashReporter] - 远程上报
// ignore: unnecessary_library_name
library crash_reporter_kit;

export 'src/crash_reporter_kit.dart';
export 'src/models/models.dart';
