import 'package:flutter/material.dart';
import 'todo_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/todo_provider.dart';
import 'add_todo_screen.dart';

class TaskDetailScreen extends ConsumerWidget {
  final Todo todo;
  final int? index;
  const TaskDetailScreen({required this.todo, this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final todos = ref.read(todosProvider);
              final idx = index ?? todos.indexWhere((t) => t.createdAt == todo.createdAt);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTodoScreen(todo: todo, index: idx),
                ),
              );
              if (result != null && result is Map && result['todo'] != null && result['index'] != null) {
                ref.read(todosProvider.notifier).updateTodo(result['index'], result['todo']);
                Navigator.pop(context); // Go back to list after edit
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${todo.title}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (todo.description != null && todo.description!.isNotEmpty)
              Text(
                'Description: ${todo.description}',
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 16),
            Text(
              'Created At: ${todo.createdAt.toString().substring(0, 10)}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            if (todo.dueDate != null)
              Text(
                'Due Date: ${todo.dueDate!.toString().substring(0, 10)}',
                style: TextStyle(fontSize: 16),
              )
            else
              Text(
                'No Due Date Set',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            SizedBox(height: 16),
            Text(
              'Status: ${todo.isDone ? "Completed" : "Pending"}',
              style: TextStyle(
                fontSize: 18,
                color: todo.isDone ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
