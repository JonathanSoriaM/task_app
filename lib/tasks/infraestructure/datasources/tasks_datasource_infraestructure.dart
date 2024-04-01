import 'package:dio/dio.dart';
import 'package:tasks/config/config.dart';
import 'package:tasks/tasks/domain/datasources/tasks_datasource.dart';
import 'package:tasks/tasks/domain/entities/tasks.dart';
import 'package:tasks/tasks/infraestructure/mapppers/tasks_mapper.dart';

class TasksdbDatasourceImpl extends TasksDataSource {
  late final Dio dio;

  TasksdbDatasourceImpl()
      : dio = Dio(BaseOptions(baseUrl: Environment.apiUrl, headers: {
          'Authorization': 'Bearer ${Environment.bearer}',
          'Content-Type': 'application/x-www-form-urlencoded'
        }));

  @override
  Future<List<Task>> getTasks(String token) async {
    final response = await dio.get<List>('', queryParameters: {'token': token});
    final List<Task> tasks = [];

    for (final task in response.data ?? []) {
      tasks.add(TasksMapper.jsonToEntity(task));
    }
    return tasks;
  }

  @override
  Future<Task> getTaskById(int id, String token) async {
    try {
      final response = await dio.get('/$id', queryParameters: {'token': token});
      print(response.data[0]);
      final task = TasksMapper.jsonToEntity(response.data[0]);

      return task;
    } catch (e) {
      print(e);
      throw Exception();
    }
  }

  @override
  Future<Task> createUpdate(Map<String, dynamic> taskLike) async {
    try {
      final int? taskId = taskLike['id'];
      final String method = (taskId == null) ? 'POST' : 'PUT';
      final String url = (taskId == null)
          ? '${Environment.apiUrl}'
          : '${Environment.apiUrl}/$taskId';
      taskLike.remove('id');

      final repsonse = await dio.request(url,
          queryParameters: taskLike, options: Options(method: method));

      final task = TasksMapper.jsonToEntity(repsonse.data['task']);

      return task;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<bool> deleteTask(int id, String token) async {
    try {
      final response =
          await dio.delete('/$id', queryParameters: {'token': token});

      return true;
    } catch (e) {
      print(e);
      throw Exception();
    }
  }
}
