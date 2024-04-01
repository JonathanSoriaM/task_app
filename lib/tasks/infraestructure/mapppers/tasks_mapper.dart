import 'package:tasks/tasks/domain/domain.dart';

class TasksMapper {
  static jsonToEntity(Map<String, dynamic> json) => Task(
        id: int.parse(json['id'].toString()),
        title: json['title'],
        is_completed: int.parse(json['is_completed'].toString()),
        due_date: json['due_date'],
        comments: json["comments"] ?? '',
        description: json['description'] ?? '',
        tags: json['tags'] ?? '',
        token: json['token'] ?? '',
        created_at: null,
        updated_at: null,
      );
}
