// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'core/routing/app_router.dart';
import 'core/theme/theme_provider.dart';

void main() {
  // 初始化 media_kit
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  runApp(
    // 1. 用 ProviderScope 包裹整个应用,这是 Riverpod 运行所必需的
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2. 监听路由 provider
    final router = ref.watch(routerProvider);
    // 3. 监听主题 provider
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Riverpod Scaffold',
      // 来自 GoRouter 的路由配置
      routerConfig: router,
      // 来自 Theme Provider 的主题配置
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: themeMode,
    );
  }
}
