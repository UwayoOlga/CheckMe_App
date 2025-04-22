import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'todo_model.dart';
import 'add_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({required this.userName});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> _todos = [];
  TodoFilter _currentFilter = TodoFilter.all;

  void _addTodo(Todo todo) {
    setState(() {
      _todos.add(todo);
      _todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  void _toggleTodoStatus(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Todo deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.pink[200],
          onPressed: () {
            // Todo: Implement undo functionality
          },
        ),
      ),
    );
  }

  List<Todo> get _filteredTodos {
    switch (_currentFilter) {
      case TodoFilter.completed:
        return _todos.where((todo) => todo.isDone).toList();
      case TodoFilter.pending:
        return _todos.where((todo) => !todo.isDone).toList();
      case TodoFilter.all:
      default:
        return _todos;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.userName}"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<TodoFilter>(
                        title: Text('All Todos'),
                        value: TodoFilter.all,
                        groupValue: _currentFilter,
                        onChanged: (value) {
                          setState(() => _currentFilter = value!);
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile<TodoFilter>(
                        title: Text('Completed'),
                        value: TodoFilter.completed,
                        groupValue: _currentFilter,
                        onChanged: (value) {
                          setState(() => _currentFilter = value!);
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile<TodoFilter>(
                        title: Text('Pending'),
                        value: TodoFilter.pending,
                        groupValue: _currentFilter,
                        onChanged: (value) {
                          setState(() => _currentFilter = value!);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          CircleAvatar(
            child: Text(widget.userName.substring(0, 1).toUpperCase()),
            backgroundColor: Colors.pink[200],
            foregroundColor: Colors.white,
          ),
          SizedBox(width: 16),
        ],
      ),
      body: _todos.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.pink[200]),
            SizedBox(height: 16),
            Text('No todos yet!', style: TextStyle(fontSize: 18)),
            Text('Tap the + button to add one', style: TextStyle(color: Colors.grey)),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _filteredTodos.length,
        itemBuilder: (context, index) {
          final todo = _filteredTodos[index];
          return Dismissible(
            key: ValueKey(todo.createdAt),
            background: Container(color: Colors.red),
            onDismissed: (_) => _deleteTodo(_todos.indexOf(todo)),
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.isDone ? TextDecoration.lineThrough : null,
                    color: todo.isDone ? Colors.grey : Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
                leading: Checkbox(
                  value: todo.isDone,
                  onChanged: (_) => _toggleTodoStatus(_todos.indexOf(todo)),
                  activeColor: Colors.pink,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (todo.description != null && todo.description!.isNotEmpty)
                      Text(todo.description!),
                    SizedBox(height: 4),
                    Text(
                      'Created: ${todo.createdAt.toString().substring(0, 10)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // Todo: Implement detail screen navigation
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push<Todo>(
            context,
            MaterialPageRoute(builder: (_) => AddTodoScreen()),
          );
          if (result != null) _addTodo(result);
        },
      ),
    );
  }
}

enum TodoFilter { all, completed, pending }