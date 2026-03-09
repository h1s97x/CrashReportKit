// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:crash_reporter_kit/crash_reporter_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化CrashReporterKit
  await CrashReporterKit.init(
    enabled: true,
    autoReport: true,
    reportUrl: 'https://crash.example.com/api/report',
    enableInDebug: true,
    appVersion: '1.0.0',
    buildNumber: '1',
    userId: 'test_user',
  );

  // 使用runZonedGuarded捕获所有异常
  CrashReporterKit.runZonedGuarded(
    () => runApp(const MyApp()),
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
      title: 'Crash Reporter Kit Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
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

  @override
  void initState() {
    super.initState();
    _loadCrashes();
  }

  Future<void> _loadCrashes() async {
    final crashes = await CrashReporterKit.getAllCrashes();
    setState(() => _crashes = crashes);
  }

  void _triggerCrash() {
    // 触发一个崩溃
    throw Exception('This is a test crash!');
  }

  void _triggerAsyncCrash() async {
    // 触发异步崩溃
    await Future.delayed(const Duration(milliseconds: 100));
    throw Exception('This is an async test crash!');
  }

  void _triggerProtectedCrash() async {
    // 使用受保护的方式运行
    await CrashReporterKit.runProtected(
      () async {
        throw Exception('This is a protected crash!');
      },
      context: 'Protected operation',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Protected crash handled!')),
    );
  }

  void _manualReport() async {
    // 手动报告崩溃
    try {
      // 模拟一些操作
      final result = 10 ~/ 0; // 除零错误
      print(result);
    } catch (e, stack) {
      await CrashReporterKit.reportCrash(
        error: e,
        stackTrace: stack,
        appState: {
          'screen': 'HomePage',
          'action': 'manual_report',
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Crash reported manually!')),
      );
    }

    await _loadCrashes();
  }

  Future<void> _clearCrashes() async {
    await CrashReporterKit.clearAllCrashes();
    await _loadCrashes();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All crashes cleared!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crash Reporter Kit Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // 操作按钮
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: _triggerCrash,
                  icon: const Icon(Icons.error),
                  label: const Text('触发同步崩溃'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _triggerAsyncCrash,
                  icon: const Icon(Icons.error_outline),
                  label: const Text('触发异步崩溃'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _triggerProtectedCrash,
                  icon: const Icon(Icons.shield),
                  label: const Text('触发受保护崩溃'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _manualReport,
                  icon: const Icon(Icons.report),
                  label: const Text('手动报告崩溃'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _clearCrashes,
                  icon: const Icon(Icons.delete),
                  label: const Text('清除所有崩溃'),
                ),
              ],
            ),
          ),

          const Divider(),

          // 崩溃列表
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '崩溃记录 (${_crashes.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          Expanded(
            child: _crashes.isEmpty
                ? const Center(
                    child: Text('暂无崩溃记录'),
                  )
                : ListView.builder(
                    itemCount: _crashes.length,
                    itemBuilder: (context, index) {
                      final crash = _crashes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: Icon(
                            crash.isReported
                                ? Icons.cloud_done
                                : Icons.cloud_off,
                            color:
                                crash.isReported ? Colors.green : Colors.grey,
                          ),
                          title: Text(
                            crash.error.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${crash.timestamp}\n'
                            '${crash.deviceInfo.os} ${crash.deviceInfo.osVersion}',
                          ),
                          isThreeLine: true,
                          trailing: Icon(
                            crash.isReported
                                ? Icons.check_circle
                                : Icons.pending,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
