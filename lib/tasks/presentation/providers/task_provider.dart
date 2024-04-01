import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/tasks/domain/domain.dart';
import 'package:tasks/tasks/presentation/providers/tasks_repository_provider.dart';

final taskProvider = StateNotifierProvider.autoDispose
    .family<TaskNotifier, TaskState, int>((ref, taskId) {
  final taskRepository = ref.watch(tasksRepositoryProvider);
  return TaskNotifier(taskRepository: taskRepository, taskId: taskId);
});

class TaskNotifier extends StateNotifier<TaskState> {
  final TasksRepository taskRepository;

  TaskNotifier({
    required this.taskRepository,
    required int taskId,
  }) : super(TaskState(id: taskId)) {
    loadTask();
  }

  Task newEmpyTask() {
    return Task(
        id: 0,
        title: '',
        is_completed: 0,
        description: '',
        comments: '',
        tags: '',
        token: '10');
  }

  Future<void> loadTask() async {
    try {
      if (state.id == 0) {
        state = state.copyWith(isLoading: false, task: newEmpyTask());
        return;
      }

      final task = await taskRepository.getTaskById(state.id, '10');

      state = state.copyWith(isLoading: false, task: task);
    } catch (e) {
      print(e);
    }
  }
}

class TaskState {
  final int id;
  final Task? task;
  final bool isLoading;
  final bool isSaving;

  TaskState(
      {required this.id,
      this.task,
      this.isLoading = true,
      this.isSaving = false});

  TaskState copyWith({int? id, Task? task, bool? isLoading, bool? isSaving}) =>
      TaskState(
          id: id ?? this.id,
          task: task ?? this.task,
          isLoading: isLoading ?? this.isLoading,
          isSaving: isSaving ?? this.isSaving);
}
