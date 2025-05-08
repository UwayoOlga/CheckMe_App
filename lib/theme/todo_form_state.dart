import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:checkme/screens/todo_model.dart';

class TodoFormNotifier extends StateNotifier<TodoFormState> {
  TodoFormNotifier() : super(TodoFormState());

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  void updateDueDate(DateTime? dueDate) {
    state = state.copyWith(dueDate: dueDate);
  }

  void updateCategory(String? category) {
    state = state.copyWith(category: category);
  }

  void submitForm() {
  }
}

class TodoFormState {
  final String title;
  final String? description;
  final DateTime? dueDate;
  final String? category;

  TodoFormState({
    this.title = '',
    this.description,
    this.dueDate,
    this.category,
  });

  TodoFormState copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    String? category,
  }) {
    return TodoFormState(
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
    );
  }
}

final todoFormProvider = StateNotifierProvider<TodoFormNotifier, TodoFormState>((ref) {
  return TodoFormNotifier();
});
