# Crash Reporter Kit - 功能特性

## 核心功能

### 1. 自动崩溃检测 🔍

自动捕获和记录应用中的所有崩溃：

- **Flutter 错误捕获**: 通过 `FlutterError.onError` 捕获 Flutter 框架错误
- **平台错误捕获**: 通过 `PlatformDispatcher.onError` 捕获平台级错误
- **异步错误捕获**: 通过 Zone 捕获异步代码中的错误
- **未处理异常**: 捕获所有未被 try-catch 处理的异常

### 2. 崩溃报告 📝

生成详细的崩溃报告：

```dart
CrashReport {
  id: 唯一标识
  error: 错误对象
  stackTrace: 堆栈跟踪
  timestamp: 发生时间
  appVersion: 应用版本
  buildNumber: 构建号
  deviceInfo: 设备信息
  appState: 应用状态
  userId: 用户ID
  isReported: 是否已上报
}
```

### 3. 设备信息收集 📱

自动收集设备信息：

- 操作系统类型（Android/iOS/Windows/Linux/macOS/Web）
- 操作系统版本
- 设备型号
- 设备品牌
- 是否物理设备
- 屏幕尺寸
- 内存大小

### 4. 本地存储 💾

崩溃报告本地持久化：

- 基于文件的存储系统
- JSON 格式序列化
- 自动清理旧崩溃
- 可配置存储数量限制
- 标记已上报状态

### 5. 远程上报 ☁️

自动上报崩溃到服务器：

- HTTP POST 请求
- JSON 格式数据
- 可配置超时时间
- 自动重试失败的上报
- 批量上报未上报的崩溃

### 6. 手动报告 ✍️

支持手动报告崩溃：

```dart
await CrashReporterKit.reportCrash(
  error: error,
  stackTrace: stackTrace,
  appState: {
    'screen': 'HomePage',
    'action': 'button_click',
  },
);
```

### 7. 受保护执行 🛡️

提供受保护的代码执行：

```dart
final result = await CrashReporterKit.runProtected(
  () async => await riskyOperation(),
  context: 'Risky operation',
);
```

### 8. Zone 保护 🔒

使用 Zone 捕获所有异常：

```dart
CrashReporterKit.runZonedGuarded(
  () => runApp(MyApp()),
  onError: (error, stack) {
    print('Error: $error');
  },
);
```

### 9. 崩溃管理 📊

管理本地崩溃报告：

```dart
// 获取所有崩溃
final crashes = await CrashReporterKit.getAllCrashes();

// 清除所有崩溃
await CrashReporterKit.clearAllCrashes();
```

### 10. 灵活配置 ⚙️

丰富的配置选项：

```dart
CrashConfig {
  enabled: 是否启用
  autoReport: 是否自动上报
  reportUrl: 上报地址
  collectDeviceInfo: 是否收集设备信息
  collectAppState: 是否收集应用状态
  maxStoredCrashes: 最大存储数量
  reportTimeout: 上报超时时间
  enableInDebug: 调试模式是否启用
  userId: 用户ID
  appVersion: 应用版本
  buildNumber: 构建号
}
```

## 使用场景

### 场景 1: 生产环境监控

```dart
await CrashReporterKit.init(
  enabled: true,
  autoReport: true,
  reportUrl: 'https://crash.example.com/api/report',
  enableInDebug: false,
  maxStoredCrashes: 20,
);
```

### 场景 2: 开发环境调试

```dart
await CrashReporterKit.init(
  enabled: true,
  autoReport: false,
  enableInDebug: true,
  maxStoredCrashes: 5,
);
```

### 场景 3: 关键操作保护

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
```

### 场景 4: 用户行为追踪

```dart
try {
  await performAction();
} catch (e, stack) {
  await CrashReporterKit.reportCrash(
    error: e,
    stackTrace: stack,
    appState: {
      'screen': currentScreen,
      'userId': currentUserId,
      'action': currentAction,
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
}
```

## 技术特点

### 1. 零侵入性

- 全局初始化，无需修改现有代码
- 自动捕获所有错误
- 不影响应用性能

### 2. 高可靠性

- 错误处理不会导致二次崩溃
- 本地存储保证数据不丢失
- 自动重试失败的上报

### 3. 易于集成

- 简单的 API 设计
- 详细的文档和示例
- 开箱即用

### 4. 灵活可配置

- 丰富的配置选项
- 支持自定义服务器
- 可选的数据收集

### 5. 跨平台支持

- Android
- iOS
- Windows
- Linux
- macOS
- Web

## 性能影响

- **内存占用**: < 5MB
- **CPU 占用**: < 1%
- **存储空间**: 每个崩溃约 10-50KB
- **网络流量**: 每次上报约 5-20KB

## 安全性

- 不收集敏感信息
- 支持用户隐私保护
- 可配置数据收集范围
- HTTPS 加密传输

## 兼容性

- Dart SDK: >= 3.0.0
- Flutter: >= 3.3.0
- Android: API 21+
- iOS: 12.0+
- Windows: 10+
- macOS: 10.14+
- Linux: 任意版本
- Web: 现代浏览器

## 依赖项

- `flutter`: Flutter SDK
- `http`: ^1.1.0 - HTTP 请求
- `path`: ^1.8.3 - 路径处理
- `path_provider`: ^2.1.0 - 文件路径

## 未来计划

- [ ] 支持符号化堆栈跟踪
- [ ] 支持崩溃分组
- [ ] 支持崩溃趋势分析
- [ ] 支持自定义上报格式
- [ ] 支持离线队列
- [ ] 支持崩溃优先级
- [ ] 支持崩溃过滤规则
- [ ] 支持崩溃通知
- [ ] 集成 Sentry/Firebase Crashlytics
- [ ] 支持 Source Maps

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License
