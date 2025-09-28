// lib/screens/add_edit_todo_screen.dart
import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../helpers/db_helper.dart';

class AddEditTodoScreen extends StatefulWidget {
  final Todo? todo;
  const AddEditTodoScreen({super.key, this.todo});

  @override
  State<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.todo?.title ?? '');
    _descCtrl = TextEditingController(text: widget.todo?.description ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final title = _titleCtrl.text.trim();
    final desc = _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim();

    if (widget.todo == null) {
      final newTodo = Todo(title: title, description: desc);
      await DBHelper.instance.insertTodo(newTodo);
    } else {
      final updated = Todo(
        id: widget.todo!.id,
        title: title,
        description: desc,
        isDone: widget.todo!.isDone,
        createdAt: widget.todo!.createdAt,
      );
      await DBHelper.instance.updateTodo(updated);
    }

    setState(() => _saving = false);
    Navigator.of(context).pop(true); // notify parent to refresh
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.todo != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Task' : 'Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description (optional)'),
                minLines: 1,
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving ? const CircularProgressIndicator() : Text(isEdit ? 'Update' : 'Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
