import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo_model.dart';
import 'package:checkme/theme/todo_form_state.dart';

class AddTodoScreen extends ConsumerStatefulWidget {
  final Todo? todo;
  final int? index;
  const AddTodoScreen({Key? key, this.todo, this.index}) : super(key: key);

  @override
  ConsumerState<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends ConsumerState<AddTodoScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      final notifier = ref.read(todoFormProvider.notifier);
      notifier.updateTitle(widget.todo!.title);
      notifier.updateDescription(widget.todo!.description ?? '');
      notifier.updateDueDate(widget.todo!.dueDate);
      notifier.updateCategory(widget.todo!.category);
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoForm = ref.watch(todoFormProvider);
    final todoFormNotifier = ref.read(todoFormProvider.notifier);

    void _submit() {
      if (todoForm.title.isNotEmpty) {
        final newTodo = Todo(
          title: todoForm.title,
          description: todoForm.description?.isEmpty ?? true ? null : todoForm.description,
          createdAt: widget.todo?.createdAt ?? DateTime.now(),
          isDone: widget.todo?.isDone ?? false,
          dueDate: todoForm.dueDate,
          category: todoForm.category,
        );
        Navigator.pop(context, {'todo': newTodo, 'index': widget.index});
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'Add Todo' : 'Edit Todo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _submit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                initialValue: todoForm.title,
                decoration: const InputDecoration(
                  labelText: 'Todo Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  todoFormNotifier.updateTitle(value);
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: todoForm.description),
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  todoFormNotifier.updateDescription(value);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: todoForm.category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: ['School', 'Personal', 'Urgent'].map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  todoFormNotifier.updateCategory(value);
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    todoForm.dueDate == null
                        ? 'No Due Date Selected'
                        : 'Due Date: ${todoForm.dueDate!.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != todoForm.dueDate) {
                        todoFormNotifier.updateDueDate(picked);
                      }
                    },
                    child: const Text('Select Due Date'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _submit,
                  child: Text(widget.todo == null ? 'SAVE' : 'UPDATE', style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
