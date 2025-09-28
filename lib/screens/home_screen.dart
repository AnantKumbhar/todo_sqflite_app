// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/todo.dart';
import 'add_edit_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> _todos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refreshTodos();
  }

  Future<void> _refreshTodos() async {
    final todos = await DBHelper.instance.getTodos();
    setState(() {
      _todos = todos;
      _loading = false;
    });
  }

  Future<void> _toggleDone(Todo t) async {
    final updated = Todo(
      id: t.id,
      title: t.title,
      description: t.description,
      isDone: t.isDone == 0 ? 1 : 0,
      createdAt: t.createdAt,
    );
    await DBHelper.instance.updateTodo(updated);
    _refreshTodos();
  }

  Future<void> _deleteTodo(int id) async {
    await DBHelper.instance.deleteTodo(id);
    _refreshTodos();
  }

  Future<void> _openAddEdit([Todo? todo]) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => AddEditTodoScreen(todo: todo)),
    );
    if (changed == true) _refreshTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todos'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _todos.isEmpty
              ? const Center(child: Text('No tasks yet — add your first one!'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _todos.length,
                  itemBuilder: (context, i) {
                    final todo = _todos[i];
                    return Dismissible(
                      key: ValueKey(todo.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => _deleteTodo(todo.id!),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        child: ListTile(
                          leading: Checkbox(
                            value: todo.isDone == 1,
                            onChanged: (_) => _toggleDone(todo),
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              decoration: todo.isDone == 1 ? TextDecoration.lineThrough : null,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: todo.description == null ? null : Text(todo.description!),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _openAddEdit(todo),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Delete task?'),
                                      content: const Text('Are you sure you want to delete this task?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
                                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) _deleteTodo(todo.id!);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddEdit(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
