import 'package:tasks/tasks/domain/entities/tasks.dart';

abstract class TasksDataSource {
  Future<List<Task>> getTasks(String token);
  Future<Task> getTaskById(int id, String token);
  Future<bool> deleteTask(int id, String token);
  Future<Task> createUpdate(Map<String, dynamic> taskLike);
}
