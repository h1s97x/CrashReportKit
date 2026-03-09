# crash_reporter_kit 快速参考

本文档提供 crash_reporter_kit 的快速参考指南。

## 快速开始

### 安装

```yaml
dependencies:
  crash_reporter_kit: ^1.0.0
```

```bash
flutter pub get
```

### 基本使用

```dart
import 'package:crash_reporter_kit/crash_reporter_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化
  await CrashReporterKit.init(
    enabled: true,
    autoReport: true,
    reportUrl: 'https://your-server.com/api/crash',
  );
  
  // 使用 Zone 保护
  CrashReporterKit.runZonedGuarded(() => runApp(MyApp()));
}
```

---

## API 速查

### 主要方法

| 方法 | 返回类型 | 说明 |
|------|---------|------|
| `init({...})` | `Future<void>` | 初始化崩溃报告系统 |
| `reportCrash({...})` | `Future<void>` | 手动报告崩溃 |
| `getAllCrashes()` | `Future<List<CrashReport>>` | 获取所有崩溃报告 |
| `clearAllCrashes()` | `Future<void>` | 清除所有崩溃报告 |
| `runProtected<T>(...)` | `Future<T?>` | 运行受保护的代码 |
| `runZonedGuarded(...)` | `void` | 在受保护的 Zone 中运行 |
| `dispose()` | `void` | 关闭崩溃报告系统 |

---

## 配置选项速查

### CrashConfig

```dart
await CrashReporterKit.init(
  enabled: true,                              // 是否启用
  autoReport: true,                           // 是否自动上报
  reportUrl: 'https://example.com/api/crash', // 上报地址
  collectDeviceInfo: true,                    // 是否收集设备信息
  collectAppState: true,                      // 是否收集应用状态
  maxStoredCrashes: 10,                       // 最大存储数量
  reportTimeout: Duration(seconds: 30),       // 上报超时时间
  enableInDebug: false,                       // 调试模式是否启用
  userId: 'user_123',                         // 用户ID
  appVersion: '1.0.0',                        // 应用版本
  buildNumber: '1',                           // 构建号
);
```

---

## 数据模型速查

### CrashReport

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

### DeviceInfo

```dart
class DeviceInfo {
  final String os;                 // 操作系统
  final String osVersion;          // 操作系统版本
  final String? model;             // 设备型号
  final String? brand;             // 设备品牌
  final bool isPhysicalDevice;     // 是否是物理设备
  final String? screenSize;        // 屏幕尺寸
  final String? memory;            // 内存大小
}
```

---

## 常用代码片段

### 1. 初始化（生产环境）

```dart
await CrashReporterKit.init(
  enabled: true,
  autoReport: true,
  reportUrl: 'https://crash.example.com/api/report',
  enableInDebug: false,
  maxStoredCrashes: 20,
  appVersion: '1.0.0',
  buildNumber: '1',
);
```

### 2. 初始化（开发环境）

```dart
await CrashReporterKit.init(
  enabled: true,
  autoReport: false,
  enableInDebug: true,
  maxStoredCrashes: 5,
);
```

### 3. 手动报告崩溃

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

### 4. 受保护执行

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

### 5. Zone 保护

```dart
CrashReporterKit.runZonedGuarded(
  () => runApp(MyApp()),
  onError: (error, stack) {
    print('Caught error: $error');
  },
);
```

### 6. 获取所有崩溃

```dart
final crashes = await CrashReporterKit.getAllCrashes();
for (final crash in crashes) {
  print('Crash: ${crash.error}');
  print('Time: ${crash.timestamp}');
  print('Reported: ${crash.isReported}');
}
```

### 7. 清除所有崩溃

```dart
await CrashReporterKit.clearAllCrashes();
```

### 8. 在 Widget 中使用

```dart
class CrashListWidget extends StatefulWidget {
  @override
  State<CrashListWidget> createState() => _CrashListWidgetState();
}

class _CrashListWidgetState extends State<CrashListWidget> {
  List<CrashReport> _crashes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCrashes();
  }

  Future<void> _loadCrashes() async {
    final crashes = await CrashReporterKit.getAllCrashes();
    setState(() {
      _crashes = crashes;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return CircularProgressIndicator();
    }
    
    return ListView.builder(
      itemCount: _crashes.length,
      itemBuilder: (context, index) {
        final crash = _crashes[index];
        return ListTile(
          title: Text(crash.error.toString()),
          subtitle: Text(crash.timestamp.toString()),
        );
      },
    );
  }
}
```

---

## 使用场景

### 场景 1: 网络请求保护

```dart
final data = await CrashReporterKit.runProtected(
  () => api.fetchData(),
  context: 'API: fetchData',
);
```

### 场景 2: 数据库操作保护

```dart
await CrashReporterKit.runProtected(
  () => database.save(data),
  context: 'Database: save',
);
```

### 场景 3: 文件操作保护

```dart
await CrashReporterKit.runProtected(
  () => file.write(content),
  context: 'File: write',
);
```

### 场景 4: 添加上下文信息

```dart
await CrashReporterKit.reportCrash(
  error: e,
  stackTrace: stack,
  appState: {
    'screen': currentScreen,
    'userId': currentUserId,
    'action': currentAction,
    'networkStatus': networkStatus,
    'timestamp': DateTime.now().toIso8601String(),
  },
);
```

---

## 平台支持

| 平台 | 状态 | 说明 |
|------|------|------|
| Android | ✅ 完全支持 | API 21+ |
| iOS | ✅ 完全支持 | iOS 12.0+ |
| Windows | ✅ 完全支持 | Windows 10+ |
| Linux | ✅ 完全支持 | 任意版本 |
| macOS | ✅ 完全支持 | macOS 10.14+ |
| Web | ✅ 完全支持 | 现代浏览器 |

---

## 服务器端接口

### 请求格式

```http
POST /api/crash HTTP/1.1
Host: your-server.com
Content-Type: application/json

{
  "id": "1709914800000",
  "error": "Exception: Something went wrong",
  "stackTrace": "#0 main (file:///path/to/file.dart:10:5)\n...",
  "timestamp": "2026-03-09T10:00:00.000Z",
  "appVersion": "1.0.0",
  "buildNumber": "1",
  "deviceInfo": {
    "os": "Android",
    "osVersion": "13",
    "model": "Pixel 7",
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

### 响应格式

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "success": true
}
```

### Node.js 示例

```javascript
app.post('/api/crash', express.json(), (req, res) => {
  const crashReport = req.body;
  
  // 保存到数据库
  db.crashes.insert(crashReport);
  
  // 发送通知
  notifyTeam(crashReport);
  
  res.json({ success: true });
});
```

---

## 常见问题

### Q: 如何在调试模式下启用？

```dart
await CrashReporterKit.init(
  enableInDebug: true,
  // ...
);
```

### Q: 如何判断崩溃是否已上报？

```dart
final crashes = await CrashReporterKit.getAllCrashes();
final unreported = crashes.where((c) => !c.isReported).toList();
print('未上报的崩溃: ${unreported.length}');
```

### Q: 如何添加自定义信息？

```dart
await CrashReporterKit.reportCrash(
  error: e,
  stackTrace: stack,
  appState: {
    'customField1': 'value1',
    'customField2': 'value2',
  },
);
```

### Q: 如何定期清理旧崩溃？

```dart
// 应用启动时
final crashes = await CrashReporterKit.getAllCrashes();
if (crashes.length > 50) {
  await CrashReporterKit.clearAllCrashes();
}
```

---

## 性能提示

### 1. 异步初始化

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 异步初始化，不阻塞应用启动
  await CrashReporterKit.init(/* ... */);
  
  runApp(MyApp());
}
```

### 2. 批量清理

```dart
// 定期清理，而不是每次都清理
if (DateTime.now().day == 1) {  // 每月1号
  await CrashReporterKit.clearAllCrashes();
}
```

### 3. 使用受保护执行

```dart
// 对关键操作使用 runProtected
// 自动捕获异常，无需手动 try-catch
final result = await CrashReporterKit.runProtected(
  () => criticalOperation(),
);
```

---

## 调试技巧

### 1. 查看崩溃详情

```dart
final crashes = await CrashReporterKit.getAllCrashes();
for (final crash in crashes) {
  print('=== Crash ${crash.id} ===');
  print('Error: ${crash.error}');
  print('Stack: ${crash.stackTrace}');
  print('Device: ${crash.deviceInfo.os} ${crash.deviceInfo.osVersion}');
  print('App State: ${crash.appState}');
  print('Reported: ${crash.isReported}');
  print('');
}
```

### 2. 测试崩溃报告

```dart
// 手动触发崩溃
try {
  throw Exception('Test crash');
} catch (e, stack) {
  await CrashReporterKit.reportCrash(
    error: e,
    stackTrace: stack,
    appState: {'test': true},
  );
}

// 验证崩溃已记录
final crashes = await CrashReporterKit.getAllCrashes();
assert(crashes.isNotEmpty);
```

---

## 相关链接

- [完整 API 文档](API.md)
- [架构设计](ARCHITECTURE.md)
- [代码风格指南](CODE_STYLE.md)
- [功能特性](FEATURES.md)
- [快速入门](GETTING_STARTED.md)
- [贡献指南](../CONTRIBUTING.md)
- [GitHub 仓库](https://github.com/h1s97x/CrashReportKit)

---

**文档版本**: 1.0  
**创建日期**: 2026-03-09  
**项目**: crash_reporter_kit
