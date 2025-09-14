import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task_bloc.dart';
import 'task_list_screen.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;

  const HomeScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        backgroundColor: theme.primaryColor,
        actions: [
          IconButton(
            icon: Icon(theme.brightness == Brightness.light ? Icons.nightlight_round : Icons.wb_sunny),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            return TaskListScreen(tasks: state.tasks);
          } else if (state is TaskError) {
            return Center(child: Text('Error: ${state.message}', style: theme.textTheme.bodyLarge));
          }
          return Center(child: Text('No tasks yet', style: theme.textTheme.bodyLarge));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primaryColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddTaskScreen(),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}