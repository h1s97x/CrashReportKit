# crash_reporter_kit 代码风格指南

本文档定义了 crash_reporter_kit 项目的代码风格规范。

## 基本原则

1. **一致性**: 保持代码风格一致
2. **可读性**: 代码应该易于理解
3. **简洁性**: 避免不必要的复杂性
4. **可维护性**: 便于后续维护和扩展

---

## Dart 代码风格

### 命名规范

#### 文件命名

使用 `snake_case`（小写下划线）:

```text
✅ 好的示例
crash_report.dart
crash_config.dart
crash_reporter_kit.dart

❌ 不好的示例
CrashReport.dart
crashReport.dart
CRASH_REPORT.dart
```

#### 类命名

使用 `PascalCase`（大驼峰）:

```dart
✅ 好的示例
class CrashReport {}
class CrashConfig {}
class CrashReporterKit {}

❌ 不好的示例
class crashReport {}
class crash_report {}
class CRASHREPORT {}
```

#### 变量和方法命名

使用 `camelCase`（小驼峰）:

```dart
✅ 好的示例
final crashReport = await CrashReporterKit.getAllCrashes();
final isReported = crashReport.isReported;

Future<void> reportCrash() async { }

❌ 不好的示例
final CrashReport = await CrashReporterKit.GetAllCrashes();
final IsReported = crashReport.IsReported;

Future<void> ReportCrash() async { }
```

#### 常量命名

使用 `lowerCamelCase`:

```dart
✅ 好的示例
const defaultTimeout = Duration(seconds: 30);
const maxStoredCrashes = 10;

❌ 不好的示例
const DEFAULT_TIMEOUT = Duration(seconds: 30);
const MAX_STORED_CRASHES = 10;
```

### 代码格式

#### 缩进

使用 2 个空格缩进:

```dart
✅ 好的示例
class CrashReport {
  final String id;
  
  CrashReport({required this.id});
}

❌ 不好的示例
class CrashReport {
    final String id;  // 4 个空格
    
    CrashReport({required this.id});
}
```

#### 行长度

每行最多 80 个字符，超过时适当换行:

```dart
✅ 好的示例
final report = CrashReport(
  id: '123',
  error: Exception('Test'),
  deviceInfo: deviceInfo,
);

❌ 不好的示例
final report = CrashReport(id: '123', error: Exception('Test'), deviceInfo: deviceInfo, timestamp: DateTime.now());
```

#### 尾随逗号

多行参数列表使用尾随逗号:

```dart
✅ 好的示例
return CrashReport(
  id: id,
  error: error,
  deviceInfo: deviceInfo,  // 尾随逗号
);

❌ 不好的示例
return CrashReport(
  id: id,
  error: error,
  deviceInfo: deviceInfo  // 缺少尾随逗号
);
```

### 类型注解

#### 公共 API

必须显式声明返回类型和参数类型:

```dart
✅ 好的示例
static Future<void> reportCrash({
  required Object error,
  StackTrace? stackTrace,
}) async {
  // ...
}

❌ 不好的示例
static reportCrash({error, stackTrace}) async {
  // ...
}
```

#### 局部变量

可以使用类型推断:

```dart
✅ 好的示例
final crashes = await CrashReporterKit.getAllCrashes();
final error = crashes.first.error;

✅ 也可以
final List<CrashReport> crashes = await CrashReporterKit.getAllCrashes();
final Object error = crashes.first.error;
```

### 文档注释

#### 公共 API

所有公共类、方法、属性必须有文档注释:

```dart
✅ 好的示例
/// 崩溃报告模型
///
/// 包含错误信息、堆栈跟踪、设备信息等。
class CrashReport {
  /// 唯一标识
  ///
  /// 使用时间戳生成，例如: "1709914800000"
  final String id;
  
  /// 手动报告崩溃
  ///
  /// 在 try-catch 块中捕获异常后，可以手动报告。
  ///
  /// 示例:
  /// ```dart
  /// try {
  ///   await riskyOperation();
  /// } catch (e, stack) {
  ///   await CrashReporterKit.reportCrash(
  ///     error: e,
  ///     stackTrace: stack,
  ///   );
  /// }
  /// ```
  static Future<void> reportCrash({
    required Object error,
    StackTrace? stackTrace,
  }) async {
    // ...
  }
}
```

#### 私有成员

使用行内注释:

```dart
✅ 好的示例
// 记录崩溃到本地存储
Future<void> _recordCrash({
  required Object error,
  StackTrace? stackTrace,
}) async {
  // 收集设备信息
  final deviceInfo = await DeviceInfo.current();
  
  // 创建崩溃报告
  final report = CrashReport(/* ... */);
}
```

### 构造函数顺序

构造函数必须在字段定义之前:

```dart
✅ 好的示例
class CrashReport {
  CrashReport({required this.id, required this.error});
  
  factory CrashReport.fromJson(Map<String, dynamic> json) {
    return CrashReport(id: json['id'], error: json['error']);
  }
  
  final String id;
  final Object error;
}

❌ 不好的示例
class CrashReport {
  final String id;
  final Object error;
  
  CrashReport({required this.id, required this.error});  // 应该在字段之前
}
```

---

## 异步编程

### 使用 async/await

```dart
✅ 好的示例
Future<void> reportCrash() async {
  final deviceInfo = await DeviceInfo.current();
  await storage.save(report);
}

❌ 不好的示例
Future<void> reportCrash() {
  return DeviceInfo.current().then((deviceInfo) {
    return storage.save(report);
  });
}
```

### 错误处理

```dart
✅ 好的示例
try {
  await storage.save(report);
} catch (e) {
  debugPrint('Failed to save crash: $e');
}

❌ 不好的示例
await storage.save(report);  // 未处理异常
```

---

## 空安全

### 正确使用可空类型

```dart
✅ 好的示例
final String? userId = config.userId;
if (userId != null) {
  print('User: $userId');
}

// 或使用 ?.
print('User: ${config.userId ?? "Unknown"}');

❌ 不好的示例
final String userId = config.userId!;  // 可能崩溃
print('User: $userId');
```

### 避免不必要的 null 检查

```dart
✅ 好的示例
Future<void> reportCrash({
  required Object error,  // 必需参数
  StackTrace? stackTrace,  // 可选参数
}) async {
  // ...
}

❌ 不好的示例
Future<void> reportCrash({
  Object? error,  // 不应该是可空的
  StackTrace? stackTrace,
}) async {
  if (error == null) return;  // 不必要的检查
  // ...
}
```

---

## 最佳实践

### 1. 使用 const

尽可能使用 `const`:

```dart
✅ 好的示例
const defaultTimeout = Duration(seconds: 30);
const maxStoredCrashes = 10;

❌ 不好的示例
final defaultTimeout = Duration(seconds: 30);
final maxStoredCrashes = 10;
```

### 2. 使用命名参数

对于多个参数的方法，使用命名参数:

```dart
✅ 好的示例
await CrashReporterKit.init(
  enabled: true,
  autoReport: true,
  reportUrl: 'https://example.com',
);

❌ 不好的示例
await CrashReporterKit.init(true, true, 'https://example.com');
```

### 3. 避免深层嵌套

```dart
✅ 好的示例
Future<void> reportCrash() async {
  if (!config.enabled) return;
  if (kDebugMode && !config.enableInDebug) return;
  
  final deviceInfo = await DeviceInfo.current();
  final report = CrashReport(/* ... */);
  await storage.save(report);
}

❌ 不好的示例
Future<void> reportCrash() async {
  if (config.enabled) {
    if (!kDebugMode || config.enableInDebug) {
      final deviceInfo = await DeviceInfo.current();
      final report = CrashReport(/* ... */);
      await storage.save(report);
    }
  }
}
```

### 4. 使用有意义的变量名

```dart
✅ 好的示例
final unreportedCrashes = crashes.where((c) => !c.isReported).toList();
final crashCount = crashes.length;

❌ 不好的示例
final list = crashes.where((c) => !c.isReported).toList();
final n = crashes.length;
```

---

## 工具

### 格式化

```bash
# 格式化所有文件
dart format .

# 检查格式（不修改）
dart format --output=none --set-exit-if-changed .
```

### 分析

```bash
# 运行代码分析
flutter analyze

# 修复可自动修复的问题
dart fix --apply
```

### 测试

```bash
# 运行所有测试
flutter test

# 运行特定测试
flutter test test/crash_reporter_kit_test.dart

# 生成覆盖率报告
flutter test --coverage
```

---

## 提交规范

遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范。

### 提交消息格式

```text
<类型>(<范围>): <简短描述>

[可选的详细描述]

[可选的 Footer]
```

### 类型

- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档变更
- `style`: 代码格式变更
- `refactor`: 代码重构
- `test`: 添加或更新测试
- `chore`: 维护任务

### 示例

```text
feat(handler): 添加自定义错误过滤器

- 添加 errorFilter 配置选项
- 实现过滤逻辑
- 添加单元测试

Closes #123
```

---

**文档版本**: 1.0  
**创建日期**: 2026-03-09  
**项目**: crash_reporter_kit
