// lib/features/demo_todos/todos_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart'; // 需要 uuid 来生成唯一的 ID
import 'models/todo.dart';

// 创建一个 Uuid 实例
const _uuid = Uuid();

// 1. Notifier 类 - 包含业务逻辑
class TodosNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() {
    // build 方法用于提供初始状态。
    // 这里我们返回一个空的待办事项列表。
    // 你也可以在这里加载持久化的数据或提供一些默认的示例数据。
    return [
      // 示例数据，方便测试
      Todo(id: _uuid.v4(), description: '学习 Riverpod', completed: true),
      Todo(id: _uuid.v4(), description: '编写 Todo Demo', completed: false),
      Todo(id: _uuid.v4(), description: '喝杯咖啡 ☕️', completed: false),
    ];
  }

  /// 添加一个新的待办事项
  void addTodo(String description) {
    // 创建一个新的 Todo 对象
    final newTodo = Todo(
      id: _uuid.v4(),
      description: description,
    );
    // 更新状态。状态是不可变的，所以我们创建一个包含旧项目和新项目的新列表。
    // 不要使用 state.add(newTodo)，那会修改原始列表，导致状态不更新。
    state = [...state, newTodo];
  }

  /// 根据 ID 删除一个待办事项
  void remove(String id) {
    // 使用 where 方法过滤掉 ID 匹配的待办事项，然后创建一个新列表。
    state = state.where((todo) => todo.id != id).toList();
  }

  /// 切换指定 ID 的待办事项的完成状态
  void toggle(String id) {
    // 使用 map 遍历列表。
    // 如果找到匹配的 ID，就创建一个新的 Todo 实例，并翻转其 `completed` 状态。
    // 否则，返回原始的 todo。
    // 最后，将结果转换回一个列表。
    state = [
      for (final todo in state)
        if (todo.id == id)
          todo.copyWith(completed: !todo.completed)
        else
          todo,
    ];
    // 上面的写法等同于：
    // state = state.map((todo) {
    //   if (todo.id == id) {
    //     return todo.copyWith(completed: !todo.completed);
    //   }
    //   return todo;
    // }).toList();
  }
}

// 2. Provider - 让 UI 可以访问到 Notifier
final todosProvider = NotifierProvider<TodosNotifier, List<Todo>>(
  TodosNotifier.new,
);
