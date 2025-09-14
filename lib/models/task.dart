import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

@HiveType(typeId: 0) // Removed part 'task.g.dart' for manual adapter
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Task.withDefaultId({
    required this.title,
    this.isCompleted = false,
  }) : id = const Uuid().v4();

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}