import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task.dart';
import '../services/hive_service.dart';

abstract class TaskEvent {}
class LoadTasks extends TaskEvent {}
class AddTask extends TaskEvent {
  final String title;
  AddTask(this.title);
}
class UpdateTask extends TaskEvent {
  final String id;
  final String newTitle;
  UpdateTask(this.id, this.newTitle);
}
class ToggleTask extends TaskEvent {
  final String id;
  ToggleTask(this.id);
}
class DeleteTask extends TaskEvent {
  final String id;
  DeleteTask(this.id);
}

abstract class TaskState {}
class TaskInitial extends TaskState {}
class TaskLoading extends TaskState {}
class TaskLoaded extends TaskState {
  final List<Task> tasks;
  TaskLoaded(this.tasks);
}
class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final HiveService hiveService;
  TaskBloc(this.hiveService) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<ToggleTask>(_onToggleTask);
    on<DeleteTask>(_onDeleteTask);
  }

  void _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = hiveService.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      try {
        final newTask = Task.withDefaultId(title: event.title);
        await hiveService.addTask(newTask);
        final updatedTasks = [...currentState.tasks, newTask];
        emit(TaskLoaded(updatedTasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    }
  }

  void _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      try {
        final index = currentState.tasks.indexWhere((task) => task.id == event.id);
        if (index != -1) {
          final updatedTask = currentState.tasks[index].copyWith(title: event.newTitle);
          await hiveService.updateTask(updatedTask);
          final updatedTasks = List<Task>.from(currentState.tasks);
          updatedTasks[index] = updatedTask;
          emit(TaskLoaded(updatedTasks));
        }
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    }
  }

  void _onToggleTask(ToggleTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      try {
        await hiveService.toggleTask(event.id);
        final updatedTasks = currentState.tasks.map((task) {
          if (task.id == event.id) {
            return task.copyWith(isCompleted: !task.isCompleted);
          }
          return task;
        }).toList();
        emit(TaskLoaded(updatedTasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    }
  }

  void _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      try {
        await hiveService.deleteTask(event.id);
        final updatedTasks = currentState.tasks.where((task) => task.id != event.id).toList();
        emit(TaskLoaded(updatedTasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    }
  }
}