import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/tasks/domain/domain.dart';
import 'package:tasks/tasks/infraestructure/datasources/tasks_datasource_infraestructure.dart';
import 'package:tasks/tasks/infraestructure/repositories/task_repository_impl.dart';

final tasksRepositoryProvider = Provider<TasksRepository>((ref) {
  final tasksRepository = TaskRepositoryImpl(TasksdbDatasourceImpl());

  return tasksRepository;
});
