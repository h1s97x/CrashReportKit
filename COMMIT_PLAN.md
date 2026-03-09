# CrashReportKit 提交方案

本文档描述了 CrashReportKit 项目的详细提交计划，采用语义化提交规范。

## 提交策略

采用原子化提交策略，每个提交专注于单一功能或改进，便于代码审查和版本管理。

---

## 提交计划

### 第 1 次提交：项目初始化和基础配置

**类型**: `chore`  
**范围**: `init`  
**描述**: 初始化项目结构和基础配置

**提交消息**:
```
chore(init): 初始化 CrashReportKit 项目

- 添加 pubspec.yaml 配置文件
- 添加 analysis_options.yaml 代码分析配置
- 添加 .gitignore 和 .pubignore
- 添加 .metadata 文件
- 配置 Flutter 3.3.0+ 和 Dart 3.0.0+ 环境
- 添加依赖: http, path, path_provider
```

**包含文件**:
- pubspec.yaml
- analysis_options.yaml
- .gitignore
- .pubignore
- .metadata

---

### 第 2 次提交：核心数据模型

**类型**: `feat`  
**范围**: `models`  
**描述**: 实现崩溃报告核心数据模型

**提交消息**:
```
feat(models): 实现崩溃报告核心数据模型

- 添加 CrashReport 模型，包含错误信息、堆栈跟踪、时间戳等
- 添加 DeviceInfo 模型，自动收集设备信息
- 添加 CrashConfig 配置模型
- 实现 JSON 序列化和反序列化
- 支持跨平台设备信息收集（Android/iOS/Windows/Linux/macOS/Web）
```

**包含文件**:
- lib/src/models/crash_report.dart
- lib/src/models/crash_config.dart
- lib/src/models/models.dart

---

### 第 3 次提交：崩溃存储功能

**类型**: `feat`  
**范围**: `storage`  
**描述**: 实现本地崩溃报告存储

**提交消息**:
```
feat(storage): 实现本地崩溃报告存储

- 添加 CrashStorage 类，基于文件系统的存储实现
- 支持保存、读取、删除崩溃报告
- 实现自动清理旧崩溃功能
- 支持标记已上报状态
- 使用 JSON 格式持久化数据
```

**包含文件**:
- lib/src/storage/crash_storage.dart

---

### 第 4 次提交：崩溃上报功能

**类型**: `feat`  
**范围**: `reporter`  
**描述**: 实现崩溃远程上报

**提交消息**:
```
feat(reporter): 实现崩溃远程上报功能

- 添加 CrashReporter 类，通过 HTTP POST 上报崩溃
- 支持自定义上报 URL
- 实现超时控制
- 添加错误处理和重试机制
- 使用 JSON 格式发送数据
```

**包含文件**:
- lib/src/reporters/crash_reporter.dart

---

### 第 5 次提交：崩溃处理器

**类型**: `feat`  
**范围**: `handler`  
**描述**: 实现自动崩溃捕获和处理

**提交消息**:
```
feat(handler): 实现自动崩溃捕获和处理

- 添加 CrashHandler 类，自动捕获 Flutter 和平台错误
- 通过 FlutterError.onError 捕获 Flutter 错误
- 通过 PlatformDispatcher.onError 捕获平台错误
- 自动收集设备信息和应用状态
- 支持自动上报未上报的崩溃
- 实现崩溃清理和管理功能
```

**包含文件**:
- lib/src/handlers/crash_handler.dart

---

### 第 6 次提交：核心 API

**类型**: `feat`  
**范围**: `api`  
**描述**: 实现 CrashReporterKit 核心 API

**提交消息**:
```
feat(api): 实现 CrashReporterKit 核心 API

- 添加 CrashReporterKit 主类，提供统一的公共 API
- 实现 init() 初始化方法
- 实现 reportCrash() 手动报告崩溃
- 实现 getAllCrashes() 获取所有崩溃
- 实现 clearAllCrashes() 清除崩溃
- 实现 runProtected() 受保护执行
- 实现 runZonedGuarded() Zone 保护
- 添加主导出文件
```

**包含文件**:
- lib/src/crash_reporter_kit.dart
- lib/crash_reporter_kit.dart

---

### 第 7 次提交：单元测试

**类型**: `test`  
**范围**: `core`  
**描述**: 添加核心功能单元测试

**提交消息**:
```
test(core): 添加核心功能单元测试

- 添加 CrashReporterKit 基础测试
- 测试初始化功能
- 测试崩溃报告功能
- 测试数据模型序列化
- 确保测试覆盖率
```

**包含文件**:
- test/crash_reporter_kit_test.dart

---

### 第 8 次提交：示例应用

**类型**: `docs`  
**范围**: `example`  
**描述**: 添加完整的示例应用

**提交消息**:
```
docs(example): 添加完整的示例应用

- 创建功能完整的示例应用
- 演示初始化和配置
- 演示手动报告崩溃
- 演示受保护执行
- 演示崩溃列表和管理
- 提供实际使用场景参考
```

**包含文件**:
- example/crash_reporter_kit_example.dart

---

### 第 9 次提交：性能基准测试

**类型**: `perf`  
**范围**: `benchmark`  
**描述**: 添加性能基准测试

**提交消息**:
```
perf(benchmark): 添加性能基准测试

- 添加崩溃报告性能测试
- 添加存储操作性能测试
- 添加设备信息收集性能测试
- 添加并发报告性能测试
- 添加重复报告性能测试
- 提供性能优化参考数据
```

**包含文件**:
- benchmark/crash_reporter_kit_benchmark.dart

---

### 第 10 次提交：项目文档

**类型**: `docs`  
**范围**: `readme`  
**描述**: 添加项目核心文档

**提交消息**:
```
docs(readme): 添加项目核心文档

- 添加 README.md 项目说明
- 添加 CHANGELOG.md 变更日志
- 添加 LICENSE MIT 许可证
- 添加 FEATURES.md 功能特性说明
- 添加 GETTING_STARTED.md 快速入门指南
- 提供完整的使用说明和示例
```

**包含文件**:
- README.md
- CHANGELOG.md
- LICENSE
- FEATURES.md
- GETTING_STARTED.md

---

### 第 11 次提交：详细文档

**类型**: `docs`  
**范围**: `documentation`  
**描述**: 添加详细技术文档

**提交消息**:
```
docs(documentation): 添加详细技术文档

- 添加 doc/API.md 完整 API 参考
- 添加 doc/ARCHITECTURE.md 架构设计文档
- 添加 doc/CODE_STYLE.md 代码风格指南
- 添加 doc/QUICK_REFERENCE.md 快速参考
- 添加 doc/GETTING_STARTED.md 详细入门指南
- 提供全面的开发和使用文档
```

**包含文件**:
- doc/API.md
- doc/ARCHITECTURE.md
- doc/CODE_STYLE.md
- doc/FEATURES.md
- doc/GETTING_STARTED.md
- doc/QUICK_REFERENCE.md

---

### 第 12 次提交：贡献指南

**类型**: `docs`  
**范围**: `contributing`  
**描述**: 添加贡献指南和开发规范

**提交消息**:
```
docs(contributing): 添加贡献指南和开发规范

- 添加 CONTRIBUTING.md 贡献指南
- 说明项目架构和代码结构
- 提供功能扩展指南
- 定义代码风格规范
- 说明测试要求
- 定义 Pull Request 流程
- 添加提交消息规范
```

**包含文件**:
- CONTRIBUTING.md

---

### 第 13 次提交：CI/CD 配置

**类型**: `ci`  
**范围**: `github`  
**描述**: 添加 GitHub Actions CI/CD 配置

**提交消息**:
```
ci(github): 添加 GitHub Actions CI/CD 配置

- 添加 Dart CI 工作流
- 配置自动化测试
- 配置代码分析
- 配置代码格式检查
- 配置代码覆盖率上传
- 支持 main 和 develop 分支
```

**包含文件**:
- .github/workflows/dart.yml
- .github/COMMIT_CONVENTION.md

---

## 提交顺序说明

1. **基础配置** → 建立项目基础
2. **数据模型** → 定义核心数据结构
3. **存储功能** → 实现数据持久化
4. **上报功能** → 实现远程通信
5. **处理器** → 实现自动捕获
6. **核心 API** → 提供统一接口
7. **测试** → 确保代码质量
8. **示例** → 提供使用参考
9. **基准测试** → 性能验证
10. **核心文档** → 基础说明
11. **详细文档** → 深入指南
12. **贡献指南** → 开发规范
13. **CI/CD** → 自动化流程

## 提交规范

遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

### 提交类型

- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档变更
- `style`: 代码格式变更
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建/工具变更
- `perf`: 性能优化
- `ci`: CI/CD 配置

### 提交格式

```
<类型>(<范围>): <简短描述>

<详细描述>

<Footer>
```

## 执行计划

按照上述顺序依次执行提交，每次提交后验证：

1. 代码格式正确：`dart format .`
2. 代码分析通过：`flutter analyze`
3. 测试通过：`flutter test`

---

**创建日期**: 2026-03-09  
**项目**: CrashReportKit  
**版本**: 1.0.0
