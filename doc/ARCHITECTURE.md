# crash_reporter_kit 架构设计

本文档描述 crash_reporter_kit 项目的架构设计原则和实现方案。

## 目录

1. [设计原则](#设计原则)
2. [目录结构](#目录结构)
3. [模块划分](#模块划分)
4. [数据流](#数据流)
5. [扩展指南](#扩展指南)

---

## 设计原则

### 1. 简单易用

提供简单直观的 API，开发者可以快速集成和使用。

**优势**:
- 快速上手
- 减少学习成本
- 降低出错概率

**示例**:

```dart
// 一行代码初始化
await CrashReporterKit.init(
  enabled: true,
  autoReport: true,
  reportUrl: 'https://your-server.com/api/crash',
);
```

### 2. 自动化

自动捕获未处理的异常，无需手动包装每个代码块。

**实现**:
- 自动捕获 Flutter 错误
- 自动捕获平台错误
- 自动上报崩溃

### 3. 类型安全

使用强类型的数据模型，避免运行时错误。

**实现**:
- 所有数据模型都有明确的类型定义
- 使用可空类型处理可能缺失的数据
- 提供 JSON 序列化/反序列化

### 4. 异步非阻塞

所有 API 都是异步的，不会阻塞 UI 线程。

**实现**:
- 使用 `Future` 返回结果
- 异步存储崩溃报告
- 异步上报崩溃

### 5. 可扩展性

易于添加新功能和自定义行为。

**实现**:
- 模块化的代码结构
- 清晰的接口定义
- 详细的扩展文档

---

## 目录结构

```text
crash_reporter_kit/
├── lib/                                    # Dart 代码
│   ├── crash_reporter_kit.dart             # 主导出文件
│   └── src/
│       ├── crash_reporter_kit.dart         # 核心 API 实现
│       ├── models/                         # 数据模型
│       │   ├── crash_report.dart
│       │   ├── crash_config.dart
│       │   └── models.dart
│       ├── handlers/                       # 崩溃处理器
│       │   └── crash_handler.dart
│       ├── reporters/                      # 崩溃上报器
│       │   └── crash_reporter.dart
│       └── storage/                        # 崩溃存储
│           └── crash_storage.dart
├── test/                                   # 单元测试
│   └── crash_reporter_kit_test.dart
├── example/                                # 示例应用
│   └── crash_reporter_kit_example.dart
├── benchmark/                              # 性能测试
│   └── crash_reporter_kit_benchmark.dart
└── doc/                                    # 文档
    ├── API.md
    ├── ARCHITECTURE.md
    ├── CODE_STYLE.md
    ├── FEATURES.md
    ├── GETTING_STARTED.md
    └── QUICK_REFERENCE.md
```

---

## 模块划分

### 核心 API 层

**职责**:
- 提供公共 API 接口
- 管理崩溃处理器生命周期
- 协调各个模块

**核心类**:

#### CrashReporterKit

主 API 类，提供所有崩溃报告功能。

```dart
class CrashReporterKit {
  static Future<void> init({...});
  static Future<void> reportCrash({...});
  static Future<List<CrashReport>> getAllCrashes();
  static Future<void> clearAllCrashes();
  static Future<T?> runProtected<T>(...);
  static void runZonedGuarded(...);
  static void dispose();
}
```

### 数据模型层

**职责**:
- 定义崩溃报告的数据结构
- 提供 JSON 序列化/反序列化
- 提供数据验证

**核心模型**:

#### CrashConfig

崩溃报告配置，包含所有配置选项。

#### CrashReport

崩溃报告模型，包含错误信息、堆栈跟踪、设备信息等。

#### DeviceInfo

设备信息模型，包含操作系统、设备型号等。

### 处理器层

**职责**:
- 捕获 Flutter 错误
- 捕获平台错误
- 记录崩溃报告
- 触发自动上报

**核心类**:

#### CrashHandler

崩溃处理器，负责捕获和处理所有异常。

```dart
class CrashHandler {
  Future<void> initialize();
  Future<void> reportCrash({...});
  Future<List<CrashReport>> getAllCrashes();
  Future<void> clearAllCrashes();
  void dispose();
}
```

### 上报器层

**职责**:
- 上报崩溃到服务器
- 处理网络请求
- 处理上报失败

**核心类**:

#### CrashReporter

崩溃上报器，负责将崩溃报告发送到服务器。

```dart
class CrashReporter {
  Future<bool> report(CrashReport report);
}
```

### 存储层

**职责**:
- 本地存储崩溃报告
- 读取崩溃报告
- 管理存储空间

**核心类**:

#### CrashStorage

崩溃存储，负责本地持久化崩溃报告。

```dart
class CrashStorage {
  Future<void> initialize();
  Future<void> save(CrashReport report);
  Future<List<CrashReport>> getAll();
  Future<CrashReport?> get(String id);
  Future<void> markAsReported(String id);
  Future<void> delete(String id);
  Future<void> cleanup(int maxCount);
  Future<void> clear();
}
```

---

## 数据流

### 崩溃捕获流程

```text
┌─────────────┐
│   Flutter   │
│   Error     │
└──────┬──────┘
       │
       │ FlutterError.onError
       ▼
┌─────────────────┐
│  CrashHandler   │
│  _handleFlutter │
│      Error      │
└──────┬──────────┘
       │
       │ _recordCrash
       ▼
┌─────────────────┐
│  CrashStorage   │
│     save()      │
└──────┬──────────┘
       │
       │ if autoReport
       ▼
┌─────────────────┐
│  CrashReporter  │
│    report()     │
└──────┬──────────┘
       │
       │ HTTP POST
       ▼
┌─────────────────┐
│     Server      │
└─────────────────┘
```

### 手动报告流程

```text
┌─────────────┐
│  User Code  │
│ reportCrash │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│CrashReporterKit │
│  reportCrash()  │
└──────┬──────────┘
       │
       ▼
┌─────────────────┐
│  CrashHandler   │
│  reportCrash()  │
└──────┬──────────┘
       │
       ▼
┌─────────────────┐
│  CrashStorage   │
│     save()      │
└──────┬──────────┘
       │
       │ if autoReport
       ▼
┌─────────────────┐
│  CrashReporter  │
│    report()     │
└─────────────────┘
```

### 受保护执行流程

```text
┌─────────────┐
│  User Code  │
│runProtected │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│CrashReporterKit │
│ runProtected()  │
└──────┬──────────┘
       │
       │ try-catch
       ▼
┌─────────────────┐
│   Callback      │
│   Execution     │
└──────┬──────────┘
       │
       │ if error
       ▼
┌─────────────────┐
│  reportCrash()  │
└─────────────────┘
```

---

## 扩展指南

### 添加自定义错误过滤器

假设要添加错误过滤功能，只报告特定类型的错误：

#### 步骤 1: 扩展 CrashConfig

```dart
class CrashConfig {
  // 现有字段...
  
  final bool Function(Object error)? errorFilter;
  
  CrashConfig({
    // 现有参数...
    this.errorFilter,
  });
}
```

#### 步骤 2: 修改 CrashHandler

```dart
class CrashHandler {
  Future<void> _recordCrash({
    required Object error,
    StackTrace? stackTrace,
    String? context,
  }) async {
    // 应用过滤器
    if (config.errorFilter != null && !config.errorFilter!(error)) {
      return; // 跳过此错误
    }
    
    // 继续记录崩溃...
  }
}
```

#### 步骤 3: 使用示例

```dart
await CrashReporterKit.init(
  enabled: true,
  errorFilter: (error) {
    // 只报告 Exception 类型的错误
    return error is Exception;
  },
);
```

### 添加自定义上报器

假设要支持多个上报目标：

#### 步骤 1: 定义接口

```dart
abstract class CrashReporterInterface {
  Future<bool> report(CrashReport report);
}
```

#### 步骤 2: 实现自定义上报器

```dart
class CustomCrashReporter implements CrashReporterInterface {
  @override
  Future<bool> report(CrashReport report) async {
    // 自定义上报逻辑
    return true;
  }
}
```

#### 步骤 3: 扩展 CrashConfig

```dart
class CrashConfig {
  // 现有字段...
  
  final List<CrashReporterInterface>? customReporters;
  
  CrashConfig({
    // 现有参数...
    this.customReporters,
  });
}
```

### 添加崩溃分析功能

假设要添加崩溃统计和分析：

#### 步骤 1: 创建分析器

```dart
class CrashAnalyzer {
  /// 获取崩溃统计
  static Future<CrashStatistics> getStatistics() async {
    final crashes = await CrashReporterKit.getAllCrashes();
    
    return CrashStatistics(
      totalCrashes: crashes.length,
      reportedCrashes: crashes.where((c) => c.isReported).length,
      unreportedCrashes: crashes.where((c) => !c.isReported).length,
      crashesByType: _groupByType(crashes),
      crashesByDate: _groupByDate(crashes),
    );
  }
  
  static Map<String, int> _groupByType(List<CrashReport> crashes) {
    final Map<String, int> result = {};
    for (final crash in crashes) {
      final type = crash.error.runtimeType.toString();
      result[type] = (result[type] ?? 0) + 1;
    }
    return result;
  }
  
  static Map<String, int> _groupByDate(List<CrashReport> crashes) {
    final Map<String, int> result = {};
    for (final crash in crashes) {
      final date = crash.timestamp.toIso8601String().split('T')[0];
      result[date] = (result[date] ?? 0) + 1;
    }
    return result;
  }
}

class CrashStatistics {
  final int totalCrashes;
  final int reportedCrashes;
  final int unreportedCrashes;
  final Map<String, int> crashesByType;
  final Map<String, int> crashesByDate;
  
  CrashStatistics({
    required this.totalCrashes,
    required this.reportedCrashes,
    required this.unreportedCrashes,
    required this.crashesByType,
    required this.crashesByDate,
  });
}
```

#### 步骤 2: 使用示例

```dart
final stats = await CrashAnalyzer.getStatistics();
print('Total crashes: ${stats.totalCrashes}');
print('Reported: ${stats.reportedCrashes}');
print('Unreported: ${stats.unreportedCrashes}');
print('By type: ${stats.crashesByType}');
```

---

## 性能优化

### 1. 异步存储

所有存储操作都是异步的，不会阻塞主线程：

```dart
Future<void> save(CrashReport report) async {
  final file = File(path.join(_directory!.path, '${report.id}.json'));
  await file.writeAsString(jsonEncode(report.toJson()));
}
```

### 2. 批量上报

可以实现批量上报功能，减少网络请求：

```dart
Future<void> reportBatch(List<CrashReport> reports) async {
  // 批量上报逻辑
}
```

### 3. 存储清理

自动清理旧崩溃，避免占用过多存储空间：

```dart
Future<void> cleanup(int maxCount) async {
  final reports = await getAll();
  
  if (reports.length > maxCount) {
    final toDelete = reports.skip(maxCount);
    
    for (final report in toDelete) {
      await delete(report.id);
    }
  }
}
```

---

## 错误处理

### 异常处理策略

1. **捕获所有异常**: 使用 try-catch 包装所有可能失败的操作
2. **静默失败**: 崩溃报告系统本身的错误不应影响应用
3. **日志记录**: 使用 debugPrint 记录错误信息

```dart
Future<void> _recordCrash({...}) async {
  try {
    // 记录崩溃逻辑
  } catch (e) {
    // 记录崩溃失败，静默处理
    debugPrint('Failed to record crash: $e');
  }
}
```

---

## 测试策略

### 单元测试

测试数据模型的序列化和反序列化：

```dart
test('CrashReport.toJson 正确序列化', () {
  final report = CrashReport(
    id: '123',
    error: Exception('Test'),
    deviceInfo: DeviceInfo(os: 'Android', osVersion: '13'),
  );
  
  final json = report.toJson();
  
  expect(json['id'], '123');
  expect(json['error'], 'Exception: Test');
});
```

### 集成测试

测试实际的崩溃捕获和报告：

```dart
testWidgets('捕获并报告崩溃', (tester) async {
  await CrashReporterKit.init(enabled: true, autoReport: false);
  
  try {
    throw Exception('Test crash');
  } catch (e, stack) {
    await CrashReporterKit.reportCrash(error: e, stackTrace: stack);
  }
  
  final crashes = await CrashReporterKit.getAllCrashes();
  expect(crashes.length, 1);
  expect(crashes[0].error.toString(), 'Exception: Test crash');
});
```

### 性能测试

使用 benchmark 测试性能：

```dart
void main() async {
  await benchmarkCrashReporting();
}

Future<void> benchmarkCrashReporting() async {
  const iterations = 100;
  final stopwatch = Stopwatch()..start();
  
  for (int i = 0; i < iterations; i++) {
    await CrashReporterKit.reportCrash(
      error: Exception('Test $i'),
      stackTrace: StackTrace.current,
    );
  }
  
  stopwatch.stop();
  print('Average: ${stopwatch.elapsedMilliseconds / iterations} ms/op');
}
```

---

## 最佳实践

### 1. 初始化时机

在应用启动时尽早初始化：

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await CrashReporterKit.init(/* ... */);
  
  CrashReporterKit.runZonedGuarded(() => runApp(MyApp()));
}
```

### 2. 添加上下文信息

为崩溃报告添加有用的上下文信息：

```dart
await CrashReporterKit.reportCrash(
  error: e,
  stackTrace: stack,
  appState: {
    'screen': currentScreen,
    'userId': currentUserId,
    'action': currentAction,
    'networkStatus': networkStatus,
  },
);
```

### 3. 使用受保护执行

对关键操作使用 runProtected：

```dart
final result = await CrashReporterKit.runProtected(
  () => criticalOperation(),
  context: 'Critical operation',
);
```

### 4. 定期清理

定期清理旧崩溃报告：

```dart
// 应用启动时
final crashes = await CrashReporterKit.getAllCrashes();
if (crashes.length > 50) {
  await CrashReporterKit.clearAllCrashes();
}
```

---

## 总结

crash_reporter_kit 的架构设计遵循以下原则：

1. **简单易用**: 提供直观的 API
2. **自动化**: 自动捕获和报告崩溃
3. **类型安全**: 强类型的数据模型
4. **高性能**: 异步非阻塞操作
5. **可扩展**: 易于添加新功能

这种设计为项目的长期发展和维护奠定了坚实的基础。

---

**文档版本**: 1.0  
**创建日期**: 2026-03-09  
**项目**: crash_reporter_kit
