# Getting Started with Crash Reporter Kit

本指南将帮助你快速开始使用 Crash Reporter Kit。

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  crash_reporter_kit: ^1.0.0
```

运行：

```bash
flutter pub get
```

## 基础使用

### 1. 初始化

在应用启动时初始化 CrashReporterKit：

```dart
import 'package:flutter/material.dart';
import 'package:crash_reporter_kit/crash_reporter_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化崩溃报告
  await CrashReporterKit.init(
    enabled: true,
    autoReport: true,
    reportUrl: 'https://your-server.com/api/crash',
    appVersion: '1.0.0',
    buildNumber: '1',
  );

  runApp(MyApp());
}
```

### 2. 使用 Zone 保护

使用 `runZonedGuarded` 捕获所有异常：

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await CrashReporterKit.init(/* ... */);

  CrashReporterKit.runZonedGuarded(
    () => runApp(MyApp()),
    onError: (error, stack) {
      print('捕获到错误: $error');
    },
  );
}
```

### 3. 手动报告崩溃

在 try-catch 块中手动报告错误：

```dart
try {
  // 可能出错的代码
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

### 4. 受保护的代码执行

使用 `runProtected` 自动处理错误：

```dart
final result = await CrashReporterKit.runProtected(
  () async {
    return await fetchData();
  },
  context: 'Fetching user data',
);

if (result == null) {
  // 操作失败，错误已自动报告
  print('操作失败');
}
```

## 配置选项

### 完整配置示例

```dart
await CrashReporterKit.init(
  // 是否启用崩溃报告
  enabled: true,
  
  // 是否自动上报崩溃
  autoReport: true,
  
  // 崩溃报告服务器地址
  reportUrl: 'https://your-server.com/api/crash',
  
  // 是否收集设备信息
  collectDeviceInfo: true,
  
  // 是否收集应用状态
  collectAppState: true,
  
  // 最多存储的崩溃数量
  maxStoredCrashes: 10,
  
  // 上报超时时间
  reportTimeout: Duration(seconds: 30),
  
  // 是否在调试模式下启用
  enableInDebug: false,
  
  // 用户ID（可选）
  userId: 'user123',
  
  // 应用版本
  appVersion: '1.0.0',
  
  // 构建号
  buildNumber: '1',
);
```

## 管理崩溃报告

### 获取所有崩溃

```dart
final crashes = await CrashReporterKit.getAllCrashes();
for (final crash in crashes) {
  print('崩溃: ${crash.error}');
  print('时间: ${crash.timestamp}');
  print('已上报: ${crash.isReported}');
}
```

### 清除所有崩溃

```dart
await CrashReporterKit.clearAllCrashes();
```

## 服务器端接口

崩溃报告会以 JSON 格式发送到你的服务器：

```json
{
  "id": "1234567890",
  "error": "Exception: Something went wrong",
  "stackTrace": "...",
  "timestamp": "2024-03-08T10:30:00.000Z",
  "appVersion": "1.0.0",
  "buildNumber": "1",
  "userId": "user123",
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
  "isReported": false
}
```

### 服务器端示例（Node.js + Express）

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

## 最佳实践

### 1. 生产环境配置

```dart
await CrashReporterKit.init(
  enabled: true,
  autoReport: true,
  reportUrl: 'https://your-server.com/api/crash',
  enableInDebug: false,  // 生产环境关闭调试模式
  maxStoredCrashes: 20,
);
```

### 2. 开发环境配置

```dart
await CrashReporterKit.init(
  enabled: true,
  autoReport: false,  // 开发时不自动上报
  enableInDebug: true,
  maxStoredCrashes: 5,
);
```

### 3. 添加上下文信息

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

### 4. 关键操作保护

```dart
// 网络请求
final data = await CrashReporterKit.runProtected(
  () => api.fetchData(),
  context: 'API: fetchData',
);

// 数据库操作
await CrashReporterKit.runProtected(
  () => database.save(data),
  context: 'Database: save',
);

// 文件操作
await CrashReporterKit.runProtected(
  () => file.write(content),
  context: 'File: write',
);
```

## 故障排除

### 崩溃未被捕获

确保在 `main()` 函数中正确初始化：

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CrashReporterKit.init(/* ... */);
  CrashReporterKit.runZonedGuarded(() => runApp(MyApp()));
}
```

### 崩溃未上报

1. 检查 `autoReport` 是否为 `true`
2. 检查 `reportUrl` 是否正确
3. 检查网络连接
4. 查看日志中的错误信息

### 调试模式下不工作

设置 `enableInDebug: true`：

```dart
await CrashReporterKit.init(
  enableInDebug: true,
  // ...
);
```

## 下一步

- 查看 [README.md](README.md) 了解更多功能
- 运行 [example](example/) 查看完整示例
- 查看 [CHANGELOG.md](CHANGELOG.md) 了解版本历史

## 支持

如有问题或建议，请访问：
- GitHub Issues: https://github.com/h1s97x/CrashReportKit/issues
- 文档: https://github.com/h1s97x/CrashReportKit
