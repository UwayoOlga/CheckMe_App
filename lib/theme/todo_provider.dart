import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/todo_model.dart';

 final todosProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>((ref) {
  return TodoListNotifier();
});

 final filterProvider = StateProvider<TodoFilter>((ref) => TodoFilter.all);

 final searchQueryProvider = StateProvider<String>((ref) => '');

 class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier() : super([]);

  void addTodo(Todo todo) {
    state = [...state, todo];
  }

  void toggleTodoStatus(int index) {
    final updated = [...state];
    updated[index] = updated[index].copyWith(isDone: !updated[index].isDone);
    state = updated;
  }

  void deleteTodo(int index) {
    final updated = [...state]..removeAt(index);
    state = updated;
  }
}

 enum TodoFilter { all, completed, pending }