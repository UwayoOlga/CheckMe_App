import 'package:flutter/material.dart';
import 'todo_model.dart';
import 'add_todo_screen.dart';
import 'todo_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final VoidCallback onLogout;
  const HomeScreen({required this.userName, required this.onLogout});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Todo> _todos = [];
  TodoFilter _currentFilter = TodoFilter.all;
  String _searchQuery = '';

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
    final deletedTodo = _todos.removeAt(index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Todo deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.pink[200],
          onPressed: () {
            setState(() {
              _todos.insert(index, deletedTodo);
            });
          },
        ),
      ),
    );
  }

  List<Todo> get _filteredTodos {
    final filteredList = _todos.where((todo) =>
    todo.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (todo.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
            false)).toList();
    switch (_currentFilter) {
      case TodoFilter.completed:
        return filteredList.where((todo) => todo.isDone).toList();
      case TodoFilter.pending:
        return filteredList.where((todo) => !todo.isDone).toList();
      case TodoFilter.all:
      default:
        return filteredList;
    }
  }

  bool _isOverdue(Todo todo) {
    return todo.dueDate?.isBefore(DateTime.now()) == true && !todo.isDone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.userName}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: TodoFilter.values
                      .map((filter) => RadioListTile<TodoFilter>(
                    title: Text(filter.name[0].toUpperCase() +
                        filter.name.substring(1)),
                    value: filter,
                    groupValue: _currentFilter,
                    onChanged: (value) {
                      setState(() => _currentFilter = value!);
                      Navigator.pop(context);
                    },
                  ))
                      .toList(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onLogout,
          ),
          CircleAvatar(
            backgroundColor: Colors.pink[200],
            foregroundColor: Colors.white,
            child: Text(widget.userName.substring(0, 1).toUpperCase()),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          _todos.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline,
                    size: 64, color: Colors.pink[200]),
                const SizedBox(height: 16),
                const Text('No todos yet!', style: TextStyle(fontSize: 18)),
                const Text('Tap the + button to add one',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
              : Expanded(
            child: ListView.builder(
              itemCount: _filteredTodos.length,
              itemBuilder: (context, index) {
                final todo = _filteredTodos[index];
                return Dismissible(
                  key: ValueKey(todo.createdAt),
                  background: Container(color: Colors.red),
                  onDismissed: (_) => _deleteTodo(_todos.indexOf(todo)),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    child: ListTile(
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isDone
                              ? TextDecoration.lineThrough
                              : null,
                          color: todo.isDone
                              ? Colors.grey
                              : Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.color,
                        ),
                      ),
                      leading: Checkbox(
                        value: todo.isDone,
                        onChanged: (_) =>
                            _toggleTodoStatus(_todos.indexOf(todo)),
                        activeColor: Colors.pink,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (todo.description != null &&
                              todo.description!.isNotEmpty)
                            Text(todo.description!),
                          const SizedBox(height: 4),
                          Text(
                            'Created: ${todo.createdAt.toString().substring(0, 10)}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          if (_isOverdue(todo))
                            const Text(
                              'Overdue',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TaskDetailScreen(todo: todo),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
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