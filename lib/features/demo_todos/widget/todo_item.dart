// lib/features/demo_todos/widgets/todo_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../todos_provider.dart';

class TodoItem extends ConsumerWidget {
  final Todo todo;

  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () {
        // 点击 ListTile 时切换待办事项的完成状态
        ref.read(todosProvider.notifier).toggle(todo.id);
      },
      leading: Checkbox(
        value: todo.completed,
        onChanged: (value) {
          // 点击 Checkbox 时也切换状态
          ref.read(todosProvider.notifier).toggle(todo.id);
        },
      ),
      title: Text(
        todo.description,
        style: TextStyle(
          // 如果已完成，则添加删除线样式
          decoration: todo.completed ? TextDecoration.lineThrough : null,
          color: todo.completed ? Colors.grey : null,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: () {
          // 点击删除按钮时移除该待办事项
          ref.read(todosProvider.notifier).remove(todo.id);
        },
      ),
    );
  }
}
