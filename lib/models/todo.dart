// lib/models/todo.dart
class Todo {
  int? id;
  String title;
  String? description;
  int isDone; // 0 = not done, 1 = done
  String createdAt; // ISO string

  Todo({
    this.id,
    required this.title,
    this.description,
    this.isDone = 0,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
      'createdAt': createdAt,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      isDone: map['isDone'] as int? ?? 0,
      createdAt: map['createdAt'] as String,
    );
  }
}
