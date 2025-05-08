class Todo {
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? dueDate;
  bool isDone;

  Todo({
    required this.title,
    this.description,
    required this.createdAt,
    this.isDone = false,
    this.dueDate,
  });
  Todo copyWith({
    String? title,
    String? description,
    DateTime? createdAt,
    bool? isDone,
  }) {
    return Todo(
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isDone: isDone ?? this.isDone,
    );
  }
}