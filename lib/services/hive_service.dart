import 'package:hive/hive.dart';
import '../models/task.dart';

class HiveService {
  static const String _boxName = 'tasks';
  late Box<Task> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Task>(_boxName); // Ensure _box is initialized
  }

  Future<void> addTask(Task task) async {
    await _box.add(task);
  }

  Future<void> updateTask(Task updatedTask) async {
    final index = _box.values.toList().indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      await _box.putAt(index, updatedTask);
    }
  }

  Future<void> deleteTask(String id) async {
    final index = _box.values.toList().indexWhere((task) => task.id == id);
    if (index != -1) {
      await _box.deleteAt(index);
    }
  }

  Future<void> toggleTask(String id) async {
    final index = _box.values.toList().indexWhere((task) => task.id == id);
    if (index != -1) {
      final task = _box.getAt(index)!;
      task.isCompleted = !task.isCompleted;
      await task.save();
    }
  }

  List<Task> getTasks() {
    return _box.values.toList();
  }
}