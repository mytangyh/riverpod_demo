// lib/features/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/theme_provider.dart';

class HomeScreen extends ConsumerWidget {
  // 完整代码
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(themeProvider.notifier);
    final currentTheme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Demos'),
        actions: [
          IconButton(
            icon: Icon(currentTheme == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              themeNotifier.toggleTheme();
            },
          )
        ],
      ),
      body: ListView(
        children: [
          _DemoTile(
            title: 'Counter Demo',
            subtitle: 'Using StateProvider',
            onTap: () => context.go('/counter'),
          ),
          _DemoTile(
            title: 'Todo List Demo',
            subtitle: 'Using StateNotifierProvider',
            onTap: () => context.go('/todos'),
          ),
          _DemoTile(
            title: 'Async Post Demo',
            subtitle: 'Using FutureProvider',
            onTap: () => context.go('/post'),
          ),
          _DemoTile(
            title: 'Md To Txt Demo',
            subtitle: 'Using Provider and StateProvider',
            onTap: () => context.go('/md2txt'),
          ),
          _DemoTile(
            title: 'Live Stream Demo',
            subtitle: 'Using fijkplayer for RTMP/HLS streaming',
            onTap: () => context.go('/live-stream'),
          ),
        ],
      ),
    );
  }
}

class _DemoTile extends StatelessWidget {
  // 完整代码
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DemoTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
