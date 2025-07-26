// lib/core/theme/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 定义一个 Notifier，它持有并可以改变状态 (ThemeMode)
class ThemeNotifier extends StateNotifier<ThemeMode> {
  // 初始状态为系统默认
  ThemeNotifier() : super(ThemeMode.system);

  void toggleTheme() {
    // 状态是不可变的，我们不能直接修改 state，而是创建一个新的状态
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

// 2. 创建一个全局的 StateNotifierProvider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
