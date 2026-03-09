# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-03-08

### Added
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

### Features
- **CrashReport**: Comprehensive crash report model with JSON serialization
- **DeviceInfo**: Device information collection (OS, version, model, brand)
- **CrashConfig**: Flexible configuration options
- **CrashHandler**: Automatic crash detection and handling
- **CrashStorage**: Local file-based crash persistence
- **CrashReporter**: HTTP-based crash reporting to remote server
- **CrashReporterKit**: Global manager with simple API

### Documentation
- Comprehensive README with usage examples
- Getting started guide
- API documentation
- Example app with UI for testing
