// lib/features/demo_async_post/post_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'post_provider.dart';

class PostScreen extends ConsumerWidget { // 完整代码
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPost = ref.watch(postProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Async Post Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(postProvider);
            },
          )
        ],
      ),
      body: Center(
        child: asyncPost.when(
          data: (post) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(post.body),
            ),
          ),
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error: $err'),
        ),
      ),
    );
  }
}
