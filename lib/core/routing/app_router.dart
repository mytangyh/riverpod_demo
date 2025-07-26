// lib/core/routing/app_router.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/demo_async_post/post_screen.dart';
import '../../features/demo_counter/counter_screen.dart';
import '../../features/demo_todos/todos_screen.dart';
import '../../features/home/home_screen.dart';

// 使用 Riverpod 提供 GoRouter 实例，方便在 App 内任何地方访问
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/counter',
        name: 'counter',
        builder: (context, state) => const CounterScreen(),
      ),
      GoRoute(
        path: '/todos',
        name: 'todos',
        builder: (context, state) => const TodosScreen(),
      ),
      GoRoute(
        path: '/post',
        name: 'post',
        builder: (context, state) => const PostScreen(),
      ),
    ],
  );
});
