import 'package:flutter/material.dart';
import 'todo_model.dart';

class TaskDetailScreen extends StatelessWidget {
  final Todo todo;
  const TaskDetailScreen({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
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
