// 一个简单的 To-do 模型
class Todo {
  final String id;
  final String description;
  final bool completed;

  Todo({required this.id, required this.description, this.completed = false});

  Todo copyWith({String? id, String? description, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}