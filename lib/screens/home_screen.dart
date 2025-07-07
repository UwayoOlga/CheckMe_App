import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/todo_provider.dart';
import '../theme/theme_provider.dart';
import 'todo_model.dart';
import 'add_todo_screen.dart';
import 'todo_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  final String userName;
  final VoidCallback onLogout;
  const HomeScreen({required this.userName, required this.onLogout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosProvider);
    final filter = ref.watch(filterProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final theme = ref.watch(themeProvider);
    final notifier = ref.read(todosProvider.notifier);
    final filterNotifier = ref.read(filterProvider.notifier);
    final searchNotifier = ref.read(searchQueryProvider.notifier);
    final themeNotifier = ref.read(themeProvider.notifier);
    final categoryNotifier = ref.read(categoryFilterProvider.notifier);
    final selectedCategory = ref.watch(categoryFilterProvider);

    // Category filter
    final categories = ['All', ...{
      ...todos.map((t) => t.category ?? '').where((c) => c.isNotEmpty)
    }];

    List<Todo> filteredTodos = todos
        .where((todo) =>
            (searchQuery.isEmpty ||
                todo.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                (todo.description?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false)) &&
            (selectedCategory == 'All' || todo.category == selectedCategory))
        .toList();
    switch (filter) {
      case TodoFilter.completed:
        filteredTodos = filteredTodos.where((todo) => todo.isDone).toList();
        break;
      case TodoFilter.pending:
        filteredTodos = filteredTodos.where((todo) => !todo.isDone).toList();
        break;
      case TodoFilter.all:
      default:
        break;
    }

    bool isOverdue(Todo todo) {
      return todo.dueDate?.isBefore(DateTime.now()) == true && !todo.isDone;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, $userName"),
        actions: [
          // Theme switcher
          PopupMenuButton<AppTheme>(
            icon: const Icon(Icons.color_lens),
            onSelected: (theme) => themeNotifier.toggleTheme(theme),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: AppTheme.light,
                child: Text('Light'),
              ),
              const PopupMenuItem(
                value: AppTheme.dark,
                child: Text('Dark'),
              ),
              const PopupMenuItem(
                value: AppTheme.system,
                child: Text('System'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: TodoFilter.values
                      .map((filter) => RadioListTile<TodoFilter>(
                            title: Text(filter.name[0].toUpperCase() + filter.name.substring(1)),
                            value: filter,
                            groupValue: filter,
                            onChanged: (value) {
                              filterNotifier.state = value!;
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
            onPressed: onLogout,
          ),
          CircleAvatar(
            backgroundColor: Colors.pink[200],
            foregroundColor: Colors.white,
            child: Text(userName.substring(0, 1).toUpperCase()),
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
              onChanged: (value) => searchNotifier.state = value,
            ),
          ),
          // Category filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              value: selectedCategory,
              items: categories.map((cat) => DropdownMenuItem(
                value: cat,
                child: Text(cat.isEmpty ? 'Uncategorized' : cat),
              )).toList(),
              onChanged: (value) {
                categoryNotifier.state = value!;
              },
            ),
          ),
          Expanded(
            child: filteredTodos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline, size: 64, color: Colors.pink[200]),
                        const SizedBox(height: 16),
                        const Text('No todos yet!', style: TextStyle(fontSize: 18)),
                        const Text('Tap the + button to add one', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = filteredTodos[index];
                      return Dismissible(
                        key: ValueKey(todo.createdAt),
                        background: Container(color: Colors.red),
                        onDismissed: (_) => notifier.deleteTodo(todos.indexOf(todo)),
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                              onChanged: (_) => notifier.toggleTodoStatus(todos.indexOf(todo)),
                              activeColor: Colors.pink,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (todo.description != null && todo.description!.isNotEmpty)
                                  Text(todo.description!),
                                const SizedBox(height: 4),
                                Text('Created: ${todo.createdAt.toString().substring(0, 10)}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                if (isOverdue(todo))
                                  const Text('Overdue', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                if (todo.category != null && todo.category!.isNotEmpty)
                                  Text('Category: ${todo.category}', style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskDetailScreen(todo: todo),
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
          if (result != null) notifier.addTodo(result);
        },
      ),
    );
  }
}