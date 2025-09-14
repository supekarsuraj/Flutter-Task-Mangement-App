import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task_bloc.dart';
import '../models/task.dart';
import 'edit_task_screen.dart';

class TaskListScreen extends StatelessWidget {
  final List<Task> tasks;

  const TaskListScreen({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pendingTasks = tasks.where((task) => !task.isCompleted).toList();
    final completedTasks = tasks.where((task) => task.isCompleted).toList();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Completed'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildTaskList(context, pendingTasks, theme),
                _buildTaskList(context, completedTasks, theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, List<Task> taskList, ThemeData theme) {
    if (taskList.isEmpty) {
      return Center(
        child: Text(
          'No tasks here',
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    return AnimatedList(
      key: ValueKey(taskList.length), // Unique key to force rebuild on list change
      initialItemCount: taskList.length,
      itemBuilder: (context, index, animation) {
        if (index >= taskList.length) return const SizedBox.shrink(); // Safety check
        final task = taskList[index];
        return FadeTransition(
          opacity: animation,
          child: Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: task.isCompleted ? Colors.green[100] : Colors.white,
            child: ListTile(
              leading: Checkbox(
                value: task.isCompleted,
                activeColor: theme.primaryColor,
                onChanged: (_) {
                  context.read<TaskBloc>().add(ToggleTask(task.id));
                },
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted ? Colors.grey : Colors.black,
                  fontSize: 18,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditTaskScreen(task: task),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<TaskBloc>().add(DeleteTask(task.id));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}