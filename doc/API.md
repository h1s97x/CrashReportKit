# crash_reporter_kit API 参考

本文档提供 crash_reporter_kit 的完整 API 参考。

## 目录

- [crash\_reporter\_kit API 参考](#crash_reporter_kit-api-参考)
  - [目录](#目录)
  - [CrashReporterKit](#crashreporterkit)
    - [静态方法](#静态方法)
      - [init](#init)
      - [reportCrash](#reportcrash)
      - [getAllCrashes](#getallcrashes)
      - [clearAllCrashes](#clearallcrashes)
      - [runProtected](#runprotected)
      - [runZonedGuarded](#runzonedguarded)
      - [dispose](#dispose)
  - [数据模型](#数据模型)
    - [CrashConfig](#crashconfig)
    - [CrashReport](#crashreport)
    - [DeviceInfo](#deviceinfo)
  - [完整示例](#完整示例)

---

## CrashReporterKit

主类，用于管理崩溃报告。

### 静态方法

#### init

```dart
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
})
```

初始化崩溃报告系统。

**参数:**
- `enabled`: 是否启用崩溃报告（默认: true）
- `autoReport`: 是否自动上报崩溃（默认: true）
- `reportUrl`: 崩溃报告服务器地址
- `collectDeviceInfo`: 是否收集设备信息（默认: true）
- `collectAppState`: 是否收集应用状态（默认: true）
- `maxStoredCrashes`: 最多存储的崩溃数量（默认: 10）
- `reportTimeout`: 上报超时时间（默认: 30秒）
- `enableInDebug`: 是否在调试模式下启用（默认: false）
- `userId`: 用户ID（可选）
- `appVersion`: 应用版本（可选）
- `buildNumber`: 构建号（可选）

**示例:**

```dart
await CrashReporterKit.init(
  enabled: true,
  autoReport: true,
  reportUrl: 'https://your-server.com/api/crash',
  appVersion: '1.0.0',
  buildNumber: '1',
);
```

#### reportCrash

```dart
static Future<void> reportCrash({
  required Object error,
  StackTrace? stackTrace,
  Map<String, dynamic>? appState,
})
```

手动报告崩溃。

**参数:**
- `error`: 错误对象（必需）
- `stackTrace`: 堆栈跟踪（可选）
- `appState`: 应用状态信息（可选）

**示例:**

```dart
try {
  await riskyOperation();
} catch (e, stack) {
  await CrashReporterKit.reportCrash(
    error: e,
    stackTrace: stack,
    appState: {
      'screen': 'HomePage',
      'action': 'button_click',
    },
  );
}
```

#### getAllCrashes

```dart
static Future<List<CrashReport>> getAllCrashes()
```

获取所有崩溃报告。

**返回:** `Future<List<CrashReport>>` - 崩溃报告列表

**示例:**

```dart
final crashes = await CrashReporterKit.getAllCrashes();
for (final crash in crashes) {
  print('Crash: ${crash.error}');
  print('Time: ${crash.timestamp}');
}
```

#### clearAllCrashes

```dart
static Future<void> clearAllCrashes()
```

清除所有崩溃报告。

**示例:**

```dart
await CrashReporterKit.clearAllCrashes();
```

#### runProtected

```dart
static Future<T?> runProtected<T>(
  Future<T> Function() callback, {
  String? context,
})
```

运行受保护的代码，自动捕获和报告异常。

**参数:**
- `callback`: 要执行的异步函数
- `context`: 上下文信息（可选）

**返回:** `Future<T?>` - 执行结果，失败时返回 null

**示例:**

```dart
final result = await CrashReporterKit.runProtected(
  () async {
    return await fetchData();
  },
  context: 'Fetching user data',
);

if (result == null) {
  print('Operation failed');
}
```

#### runZonedGuarded

```dart
static void runZonedGuarded(
  void Function() body, {
  void Function(Object error, StackTrace stack)? onError,
})
```

在受保护的 Zone 中运行代码，捕获所有未处理的异常。

**参数:**
- `body`: 要执行的函数
- `onError`: 错误回调（可选）

**示例:**

```dart
CrashReporterKit.runZonedGuarded(
  () => runApp(MyApp()),
  onError: (error, stack) {
    print('Caught error: $error');
  },
);
```

#### dispose

```dart
static void dispose()
```

关闭崩溃报告系统，恢复原始错误处理器。

**示例:**

```dart
CrashReporterKit.dispose();
```

---

## 数据模型

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
  
  // 转换为JSON
  Map<String, dynamic> toJson();
  
  // 从JSON创建
  factory CrashReport.fromJson(Map<String, dynamic> json);
  
  // 复制并修改
  CrashReport copyWith({bool? isReported});
}
```

### DeviceInfo

设备信息模型。

```dart
class DeviceInfo {
  final String os;                 // 操作系统
  final String osVersion;          // 操作系统版本
  final String? model;             // 设备型号
  final String? brand;             // 设备品牌
  final bool isPhysicalDevice;     // 是否是物理设备
  final String? screenSize;        // 屏幕尺寸
  final String? memory;            // 内存大小
  
  // 转换为JSON
  Map<String, dynamic> toJson();
  
  // 从JSON创建
  factory DeviceInfo.fromJson(Map<String, dynamic> json);
  
  // 获取当前设备信息
  static Future<DeviceInfo> current();
}
```

---

## 完整示例

```dart
import 'package:flutter/material.dart';
import 'package:crash_reporter_kit/crash_reporter_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化崩溃报告
  await CrashReporterKit.init(
    enabled: true,
    autoReport: true,
    reportUrl: 'https://crash.example.com/api/report',
    appVersion: '1.0.0',
    buildNumber: '1',
    userId: 'user_123',
  );

  // 使用 runZonedGuarded 捕获所有异常
  CrashReporterKit.runZonedGuarded(
    () => runApp(MyApp()),
    onError: (error, stack) {
      print('Caught error: $error');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crash Reporter Demo',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CrashReport> _crashes = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadCrashes();
  }

  Future<void> _loadCrashes() async {
    setState(() => _loading = true);
    
    final crashes = await CrashReporterKit.getAllCrashes();
    
    setState(() {
      _crashes = crashes;
      _loading = false;
    });
  }

  Future<void> _testCrash() async {
    try {
      throw Exception('Test crash');
    } catch (e, stack) {
      await CrashReporterKit.reportCrash(
        error: e,
        stackTrace: stack,
        appState: {
          'screen': 'HomePage',
          'action': 'test_crash',
        },
      );
      
      await _loadCrashes();
    }
  }

  Future<void> _testProtected() async {
    final result = await CrashReporterKit.runProtected(
      () async {
        throw Exception('Protected crash');
      },
      context: 'Test protected operation',
    );
    
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Operation failed')),
      );
    }
    
    await _loadCrashes();
  }

  Future<void> _clearCrashes() async {
    await CrashReporterKit.clearAllCrashes();
    await _loadCrashes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crash Reporter Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearCrashes,
            tooltip: 'Clear all crashes',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _crashes.length,
              itemBuilder: (context, index) {
                final crash = _crashes[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(crash.error.toString()),
                    subtitle: Text(
                      'Time: ${crash.timestamp}\n'
                      'Reported: ${crash.isReported}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _testCrash,
            tooltip: 'Test crash',
            child: const Icon(Icons.bug_report),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: _testProtected,
            tooltip: 'Test protected',
            child: const Icon(Icons.shield),
          ),
        ],
      ),
    );
  }
}
```

---

**文档版本**: 1.0  
**更新日期**: 2026-03-09  
**项目**: crash_reporter_kit
