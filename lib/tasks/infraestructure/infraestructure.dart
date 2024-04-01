import 'package:tasks/tasks/domain/datasources/tasks_datasource.dart';
import 'package:tasks/tasks/domain/entities/tasks.dart';
import 'package:tasks/tasks/domain/repositories/tesks_repository.dart';

class TastsRepositoryImpl extends TasksRepository {
  final TasksDataSource dataSource;

  TastsRepositoryImpl(this.dataSource);

  @override
  Future<Task> getTaskById(int id, String token) {
    return dataSource.getTaskById(id, token);
  }

  @override
  Future<List<Task>> getTasks(String token) {
    return dataSource.getTasks(token);
  }

  @override
  Future<Task> createUpdate(Map<String, dynamic> taskLike) {
    return dataSource.createUpdate(taskLike);
  }

  @override
  Future<bool> deleteTask(int id, String token) {
    return dataSource.deleteTask(id, token);
  }
}
