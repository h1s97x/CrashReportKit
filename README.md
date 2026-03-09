# crash_reporter_kit

一个功能完善的Flutter崩溃报告工具包，自动捕获和上报应用崩溃。

## 功能特性

- 💥 **自动崩溃捕获** - 自动捕获Flutter和平台错误
- 📤 **自动上报** - 自动上报崩溃到服务器
- 💾 **本地存储** - 离线存储崩溃报告
- 📱 **设备信息** - 自动收集设备信息
- 🔍 **应用状态** - 记录崩溃时的应用状态
- 🛡️ **受保护执行** - 提供受保护的代码执行环境
- 📊 **崩溃统计** - 查看和管理崩溃报告
- ⚡ **轻量级** - 不影响应用性能

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  crash_reporter_kit:
    path: ../crash_reporter_kit  # 本地路径
```

## 使用方法

### 1. 初始化

```dart
import 'package:flutter/material.dart';
import 'package:crash_reporter_kit/crash_reporter_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化CrashReporterKit
  await CrashReporterKit.init(
    enabled: true,
    autoReport: true,
    reportUrl: 'https://crash.example.com/api/report',
    enableInDebug: false,  // 生产环境设为true
    appVersion: '1.0.0',
    buildNumber: '1',
    userId: 'user_123',
  );

  // 使用runZonedGuarded捕获所有异常
  CrashReporterKit.runZonedGuarded(
    () => runApp(MyApp()),
  );
}
```

### 2. 自动崩溃捕获

初始化后，所有未捕获的异常都会自动被捕获和上报：

```dart
// Flutter错误会自动捕获
Widget build(BuildContext context) {
  // 如果这里抛出异常，会自动被捕获
  throw Exception('Widget build error');
}

// 异步错误也会自动捕获
Future<void> fetchData() async {
  // 如果这里抛出异常，会自动被捕获
  throw Exception('Async error');
}
```

### 3. 手动报告崩溃

```dart
try {
  // 可能抛出异常的代码
  final result = riskyOperation();
} catch (e, stack) {
  // 手动报告崩溃
  await CrashReporterKit.reportCrash(
    error: e,
    stackTrace: stack,
    appState: {
      'screen': 'HomePage',
      'action': 'riskyOperation',
    },
  );
}
```

### 4. 受保护的代码执行

```dart
// 使用runProtected执行可能失败的代码
final result = await CrashReporterKit.runProtected(
  () async {
    return await riskyOperation();
  },
  context: 'Risky operation',
);

if (result == null) {
  // 操作失败，已自动报告崩溃
  print('Operation failed');
}
```

### 5. 查看崩溃报告

```dart
// 获取所有崩溃报告
final crashes = await CrashReporterKit.getAllCrashes();

for (final crash in crashes) {
  print('Crash: ${crash.error}');
  print('Time: ${crash.timestamp}');
  print('Reported: ${crash.isReported}');
  print('Device: ${crash.deviceInfo.os}');
}
```

### 6. 清除崩溃报告

```dart
// 清除所有崩溃报告
await CrashReporterKit.clearAllCrashes();
```

## API参考

### CrashReporterKit

全局崩溃报告管理器。

#### 方法

- `static Future<void> init({...})` - 初始化
- `static Future<void> reportCrash({...})` - 手动报告崩溃
- `static Future<List<CrashReport>> getAllCrashes()` - 获取所有崩溃
- `static Future<void> clearAllCrashes()` - 清除所有崩溃
- `static Future<T?> runProtected<T>(...)` - 运行受保护的代码
- `static void runZonedGuarded(...)` - 运行受保护的Zone
- `static void dispose()` - 关闭

### CrashConfig

崩溃报告配置。

```dart
class CrashConfig {
  final bool enabled;              // 是否启用
  final bool autoReport;           // 是否自动上报
  final String? reportUrl;         // 上报URL
  final bool collectDeviceInfo;    // 是否收集设备信息
  final bool collectAppState;      // 是否收集应用状态
  final int maxStoredCrashes;      // 最大存储数量
  final Duration reportTimeout;    // 上报超时
  final bool enableInDebug;        // 调试模式是否启用
  final String? userId;            // 用户ID
  final String? appVersion;        // 应用版本
  final String? buildNumber;       // 构建号
}
```

### CrashReport

崩溃报告模型。

```dart
class CrashReport {
  final String id;                 // 唯一标识
  final Object error;              // 错误对象
  final StackTrace? stackTrace;    // 堆栈跟踪
  final DateTime timestamp;        // 时间戳
  final String? appVersion;        // 应用版本
  final String? buildNumber;       // 构建号
  final DeviceInfo deviceInfo;     // 设备信息
  final Map<String, dynamic>? appState;  // 应用状态
  final String? userId;            // 用户ID
  final bool isReported;           // 是否已上报
}
```

## 崩溃报告格式

### JSON格式

```json
{
  "id": "1709914800000",
  "error": "Exception: Something went wrong",
  "stackTrace": "#0      main (file:///path/to/file.dart:10:5)\n...",
  "timestamp": "2026-03-08T23:00:00.000Z",
  "appVersion": "1.0.0",
  "buildNumber": "1",
  "deviceInfo": {
    "os": "Android",
    "osVersion": "13",
    "model": "Pixel 6",
    "brand": "Google",
    "isPhysicalDevice": true
  },
  "appState": {
    "screen": "HomePage",
    "action": "button_click"
  },
  "userId": "user_123",
  "isReported": false
}
```

## 与log_kit集成

crash_reporter_kit可以与log_kit完美集成：

```dart
import 'package:log_kit/log_kit.dart';
import 'package:crash_reporter_kit/crash_reporter_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化日志
  LogKit.init(
    enableFile: true,
    enableRemote: true,
  );

  // 初始化崩溃报告
  await CrashReporterKit.init(
    enabled: true,
    autoReport: true,
    reportUrl: 'https://crash.example.com/api/report',
  );

  // 捕获崩溃并记录日志
  CrashReporterKit.runZonedGuarded(
    () => runApp(MyApp()),
    onError: (error, stack) {
      // 同时记录到日志
      LogKit.f(
        'Application crashed',
        tag: 'CRASH',
        error: error,
        stackTrace: stack,
      );
    },
  );
}
```

## 最佳实践

### 1. 生产环境配置

```dart
CrashReporterKit.init(
  enabled: true,
  autoReport: true,
  reportUrl: 'https://crash.sdu.edu.cn/api/report',
  enableInDebug: false,  // 只在生产环境启用
  collectDeviceInfo: true,
  collectAppState: true,
  maxStoredCrashes: 10,
);
```

### 2. 开发环境配置

```dart
CrashReporterKit.init(
  enabled: true,
  autoReport: false,  // 不自动上报
  enableInDebug: true,
  collectDeviceInfo: true,
  collectAppState: true,
);
```

### 3. 关键操作使用受保护执行

```dart
// 网络请求
final data = await CrashReporterKit.runProtected(
  () => api.fetchData(),
  context: 'API fetch data',
);

// 数据库操作
final result = await CrashReporterKit.runProtected(
  () => database.query(),
  context: 'Database query',
);
```

### 4. 定期清理旧崩溃

```dart
// 应用启动时清理旧崩溃
final crashes = await CrashReporterKit.getAllCrashes();
if (crashes.length > 20) {
  await CrashReporterKit.clearAllCrashes();
}
```

## 服务器端接口

崩溃报告会POST到指定的URL，格式为JSON：

```http
POST /api/report HTTP/1.1
Host: crash.example.com
Content-Type: application/json

{
  "id": "1709914800000",
  "error": "Exception: Something went wrong",
  "stackTrace": "...",
  "timestamp": "2026-03-08T23:00:00.000Z",
  "appVersion": "1.0.0",
  "deviceInfo": {...},
  "appState": {...},
  "userId": "user_123"
}
```

服务器应返回200-299状态码表示成功。

## 示例应用

查看 [example](example) 目录获取完整示例。

## 常见问题

### Q: 如何在调试模式下启用？

A: 设置 `enableInDebug: true`

### Q: 崩溃报告存储在哪里？

A: 存储在应用文档目录的 `crashes/` 文件夹

### Q: 如何自定义上报逻辑？

A: 可以设置 `autoReport: false`，然后手动调用 `reportCrash`

### Q: 如何查看崩溃详情？

A: 使用 `getAllCrashes()` 获取所有崩溃报告

## 许可证

MIT License

---

**开发团队**: SDU网络管理委员会
**版本**: 1.0.0
