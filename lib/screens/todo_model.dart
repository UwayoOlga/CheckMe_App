class Todo {
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? dueDate;
  final String? category;
  bool isDone;

  Todo({
    required this.title,
    this.description,
    required this.createdAt,
    this.isDone = false,
    this.dueDate,
    this.category,
  });

  Todo copyWith({
    String? title,
    String? description,
    DateTime? createdAt,
    bool? isDone,
    DateTime? dueDate,
    String? category,
  }) {
    return Todo(
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isDone: isDone ?? this.isDone,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
    );
  }
}
enum TodoFilter { all, completed, pending }

