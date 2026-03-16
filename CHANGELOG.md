# Changelog | 更新日志

## Table of Contents | 目录

- [English](#english)
- [中文](#中文)

---

## English

### [1.0.2] - 2026-03-16

#### Added

- Comprehensive dartdoc comments for all public APIs
- Detailed documentation for CrashReporterKit class
- Documentation for CrashReport and DeviceInfo models
- Documentation for CrashConfig configuration class
- Documentation for CrashHandler, CrashStorage, and CrashReporter classes
- Usage examples in dartdoc comments

#### Changed

- Enhanced documentation structure with detailed examples
- Improved API documentation clarity

#### Fixed

- Documentation completeness for better IDE support

### [1.0.1] - 2026-03-16

#### Added

- Bilingual changelog with index
- Automated pub.dev publishing workflow via GitHub Actions
- Version bump to 1.0.1

#### Changed

- Enhanced documentation structure with dual language support

#### Fixed

- Documentation improvements

### [1.0.0] - 2026-03-08

#### Added

- Initial release of crash_reporter_kit
- Automatic crash detection and reporting
- Flutter error handling with FlutterError.onError
- Platform error handling with PlatformDispatcher.onError
- Local crash storage with file-based persistence
- Remote crash reporting with HTTP upload
- Device information collection
- App state collection
- Manual crash reporting
- Protected code execution with runProtected
- Zone-based error handling with runZonedGuarded
- Crash report management (get all, clear all)
- Automatic retry for failed uploads
- Configurable crash storage limits
- Debug mode support
- User ID tracking
- App version and build number tracking

#### Features

- **CrashReport**: Comprehensive crash report model with JSON serialization
- **DeviceInfo**: Device information collection (OS, version, model, brand)
- **CrashConfig**: Flexible configuration options
- **CrashHandler**: Automatic crash detection and handling
- **CrashStorage**: Local file-based crash persistence
- **CrashReporter**: HTTP-based crash reporting to remote server
- **CrashReporterKit**: Global manager with simple API

#### Documentation

- Comprehensive README with usage examples
- Getting started guide
- API documentation
- Example app with UI for testing

---

## 中文

### [1.0.2] - 2026-03-16

#### 新增

- 为所有公共 API 添加完整的 dartdoc 注释
- CrashReporterKit 类的详细文档
- CrashReport 和 DeviceInfo 模型的文档
- CrashConfig 配置类的文档
- CrashHandler、CrashStorage 和 CrashReporter 类的文档
- dartdoc 注释中的使用示例

#### 变更

- 增强文档结构，提供详细示例
- 改进 API 文档清晰度

#### 修复

- 完善文档以获得更好的 IDE 支持

### [1.0.1] - 2026-03-16

#### 新增

- 双语更新日志及索引
- 通过 GitHub Actions 自动化发布到 pub.dev 的工作流
- 版本号更新至 1.0.1

#### 变更

- 增强文档结构，支持双语

#### 修复

- 文档改进

### [1.0.0] - 2026-03-08

#### 新增

- 首次发布 crash_reporter_kit
- 自动崩溃检测和上报
- 通过 FlutterError.onError 处理 Flutter 错误
- 通过 PlatformDispatcher.onError 处理平台错误
- 基于文件的本地崩溃存储
- 通过 HTTP 上传远程崩溃报告
- 设备信息收集
- 应用状态收集
- 手动崩溃报告
- 通过 runProtected 进行受保护的代码执行
- 通过 runZonedGuarded 进行基于 Zone 的错误处理
- 崩溃报告管理（获取全部、清除全部）
- 失败上传的自动重试
- 可配置的崩溃存储限制
- 调试模式支持
- 用户 ID 跟踪
- 应用版本和构建号跟踪

#### 功能

- **CrashReport**: 完整的崩溃报告模型，支持 JSON 序列化
- **DeviceInfo**: 设备信息收集（操作系统、版本、型号、品牌）
- **CrashConfig**: 灵活的配置选项
- **CrashHandler**: 自动崩溃检测和处理
- **CrashStorage**: 基于文件的本地崩溃持久化
- **CrashReporter**: 基于 HTTP 的远程崩溃报告
- **CrashReporterKit**: 具有简单 API 的全局管理器

#### 文档

- 包含使用示例的完整 README
- 快速入门指南
- API 文档
- 带有 UI 的示例应用程序用于测试
