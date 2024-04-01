class Task {
  int id;
  String title;
  String description;
  String comments;
  String tags;
  int is_completed;
  String? due_date;
  DateTime? created_at;
  DateTime? updated_at;
  String token;

  Task(
      {required this.id,
      required this.title,
      required this.description,
      required this.comments,
      required this.tags,
      required this.is_completed,
      this.due_date,
      this.created_at,
      this.updated_at,
      required this.token});
}
