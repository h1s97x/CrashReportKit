# 贡献指南

感谢您对本项目的关注！本指南将帮助您扩展插件功能。

[English Version](CONTRIBUTING_EN.md)

## 架构概览

```text
crash_reporter_kit/
├── lib/
│   ├── crash_reporter_kit.dart          # 主导出文件
│   └── src/
│       ├── crash_reporter_kit.dart      # 主 API 类
│       ├── models/                       # 数据模型
│       │   ├── crash_report.dart
│       │   ├── crash_config.dart
│       │   └── models.dart
│       ├── handlers/                     # 崩溃处理器
│       │   └── crash_handler.dart
│       ├── reporters/                    # 崩溃上报器
│       │   └── crash_reporter.dart
│       └── storage/                      # 崩溃存储
│           └── crash_storage.dart
│
├── test/                                 # 测试文件
│   └── crash_reporter_kit_test.dart
│
├── example/                              # 示例应用
│   └── crash_reporter_kit_example.dart
│
└── benchmark/                            # 性能基准测试
    └── crash_reporter_kit_benchmark.dart
```

## 添加新功能

### 步骤 1：定义数据模型

在 `lib/src/models/` 创建新模型：

```dart
// lib/src/models/new_feature.dart
class NewFeature {
  final String? property1;
  final int? property2;

  NewFeature({
    this.property1,
    this.property2,
  });

  factory NewFeature.fromJson(Map<String, dynamic> json) {
    return NewFeature(
      property1: json['property1'] as String?,
      property2: json['property2'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'property1': property1,
      'property2': property2,
    };
  }
}
```

### 步骤 2：添加到 CrashReport

更新 `lib/src/models/crash_report.dart`。

### 步骤 3：添加 API 方法

在 `lib/src/crash_reporter_kit.dart` 中添加新方法。

### 步骤 4：实现处理逻辑

在 `lib/src/handlers/crash_handler.dart` 中实现。

### 步骤 5：添加测试

创建相应的测试文件。

### 步骤 6：更新文档

更新 README.md、API.md 等文档。

## 代码风格指南

### Dart 代码

- 遵循 [Effective Dart](https://dart.dev/guides/language/effective-dart) 指南
- 使用 `dart format` 格式化代码
- 运行 `flutter analyze` 检查问题
- 为公共 API 添加文档注释

### 代码规范

- 使用有意义的变量名
- 为复杂逻辑添加注释
- 适当处理错误和异常
- 使用空安全

## 测试

### 单元测试

```bash
flutter test
```

### 性能测试

```bash
dart run benchmark/crash_reporter_kit_benchmark.dart
```

## Pull Request 流程

1. Fork 仓库
2. 创建功能分支：`git checkout -b feature/new-feature`
3. 进行修改
4. 为新功能添加测试
5. 确保所有测试通过：`flutter test`
6. 确保代码分析通过：`flutter analyze`
7. 格式化代码：`dart format .`
8. 提交并附上描述性消息：`git commit -m "feat: 添加新功能"`
9. 推送到您的 fork：`git push origin feature/new-feature`
10. 创建 Pull Request

### 提交消息格式

遵循 [Conventional Commits](https://www.conventionalcommits.org/)：

```text
<类型>(<范围>): <主题>

<正文>

<页脚>
```

类型：

- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档变更
- `style`: 代码格式变更
- `refactor`: 代码重构
- `test`: 添加或更新测试
- `chore`: 维护任务

示例：

```text
feat(handler): 添加自定义错误过滤器
fix(storage): 修正崩溃报告序列化问题
docs: 更新 API 参考文档
```

## 获取帮助

- 查看现有 [issues](https://github.com/h1s97x/CrashReportKit/issues)
- 阅读 [文档](https://github.com/h1s97x/CrashReportKit/tree/main/doc)
- 在 [discussions](https://github.com/h1s97x/CrashReportKit/discussions) 提问

## 行为准则

- 尊重和包容
- 提供建设性反馈
- 关注对社区最有利的事情
- 对其他社区成员表现出同理心

## 许可证

通过贡献，您同意您的贡献将在 MIT 许可证下授权。

## 致谢

贡献者将在以下位置获得认可：

- `AUTHORS` 文件
- 发布说明
- 项目 README

感谢您为 crash_reporter_kit 做出贡献！
