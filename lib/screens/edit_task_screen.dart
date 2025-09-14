import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task_bloc.dart';
import '../models/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Edit Task', textAlign: TextAlign.center),
      content: TextField(
        controller: _titleController,
        decoration: InputDecoration(
          hintText: 'Enter new task title',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              context.read<TaskBloc>().add(UpdateTask(widget.task.id, _titleController.text));
              Navigator.pop(context);
            }
          },
          child: const Text('Update'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}