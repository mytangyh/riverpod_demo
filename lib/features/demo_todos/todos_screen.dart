// lib/features/demo_todos/todos_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_demo/features/demo_todos/widget/todo_item.dart';
import 'todos_provider.dart';

class TodosScreen extends ConsumerStatefulWidget {
  const TodosScreen({super.key});

  @override
  ConsumerState<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends ConsumerState<TodosScreen> {
  // 使用 TextEditingController 来管理输入框的文本
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    // 记得在 widget 销毁时释放 controller
    _textEditingController.dispose();
    super.dispose();
  }

  void _addTodo() {
    final description = _textEditingController.text;
    // 只有当输入不为空时才添加
    if (description.trim().isNotEmpty) {
      ref.read(todosProvider.notifier).addTodo(description);
      // 添加后清空输入框
      _textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 监听 todos 列表
    final todos = ref.watch(todosProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: const Text('Todo List Demo'),
      ),
      body: Column(
        children: [
          // 顶部输入和添加区域
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      labelText: 'What needs to be done?',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTodo(), // 按下回车键也能添加
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: _addTodo, // 点击按钮添加
                  tooltip: 'Add Todo',
                ),
              ],
            ),
          ),

          // 分隔线
          const Divider(),

          // 待办事项列表
          Expanded(
            child: todos.isEmpty
                ? const Center(
                    child: Text(
                      'All done! Add a new task above.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      // 使用独立的 TodoItem widget
                      return TodoItem(todo: todo);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
