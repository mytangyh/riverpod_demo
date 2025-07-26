// lib/features/demo_counter/counter_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'counter_provider.dart';

class CounterScreen extends ConsumerWidget { // 完整代码
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    ref.listen<int>(counterProvider, (previous, next) {
      if (next == 5) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Count reached 5!')));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Counter Demo')),
      body: Center(
        child: Text(
          '$count',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(counterProvider.notifier).state++;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
