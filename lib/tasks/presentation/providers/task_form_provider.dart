import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:tasks/shared/infraestructure/inputs/title.dart';
import 'package:tasks/tasks/domain/domain.dart';
import 'package:tasks/tasks/presentation/providers/tasks_provider.dart';

final taskFormProvider = StateNotifierProvider.autoDispose
    .family<TaskFormNotifier, TaskFormState, Task>((ref, task) {
  final createUpdateCallback =
      ref.watch(tasksProvider.notifier).createOrUpdateTask;
  return TaskFormNotifier(task: task, onSubmitCallback: createUpdateCallback);
});

class TaskFormNotifier extends StateNotifier<TaskFormState> {
  final Future<bool> Function(Map<String, dynamic> taskLike)? onSubmitCallback;

  TaskFormNotifier({this.onSubmitCallback, required Task task})
      : super(TaskFormState(
            id: task.id,
            title: Title.dirty(task.title),
            comments: task.comments,
            description: task.description,
            is_completed: task.is_completed,
            due_date: task.due_date ?? '',
            tags: task.tags));

  Future<bool> onFormSubmit() async {
    _touchEverything();
    if (!state.isFormValid) return false;
    if (onSubmitCallback == null) return false;

    final taskLike = {
      'id': (state.id == 0) ? null : state.id,
      'title': state.title.value,
      'description': state.description,
      'comments': state.comments,
      'is_completed': state.is_completed,
      'token': state.token,
      'tags': state.tags
    };

    try {
      return await onSubmitCallback!(taskLike);
    } catch (e) {
      return false;
    }
  }

  void _touchEverything() {
    state = state.copyWith(
        isFormValid: Formz.validate([
      Title.dirty(state.title.value),
    ]));
  }

  void ontitleChanged(String value) {
    state = state.copyWith(
        title: Title.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
        ]));
  }

  void onDescriptionChanged(String description) {
    state = state.copyWith(description: description);
  }

  void onCommentsChanged(String comments) {
    state = state.copyWith(comments: comments);
  }

  void onDueDateChanged(String date) {
    state = state.copyWith(due_date: date);
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(tags: tags);
  }

  void onCompletedChanged(int completed) {
    state = state.copyWith(is_completed: completed);
  }
}

class TaskFormState {
  final bool isFormValid;
  final int? id;
  final Title title;
  final String description;
  final String comments;
  final int is_completed;
  final String due_date;
  final String tags;
  final String token;

  TaskFormState(
      {this.isFormValid = false,
      this.id,
      this.title = const Title.dirty(''),
      this.comments = '',
      this.description = '',
      this.is_completed = 0,
      this.token = '10',
      this.due_date = '',
      this.tags = ''});

  TaskFormState copyWith(
          {bool? isFormValid,
          int? id,
          Title? title,
          String? description,
          String? comments,
          int? is_completed,
          String? token,
          String? due_date,
          String? tags}) =>
      TaskFormState(
          isFormValid: isFormValid ?? this.isFormValid,
          id: id ?? this.id,
          title: title ?? this.title,
          description: description ?? this.description,
          comments: comments ?? this.comments,
          is_completed: is_completed ?? this.is_completed,
          token: token ?? this.token,
          due_date: due_date ?? this.due_date,
          tags: tags ?? this.tags);
}
