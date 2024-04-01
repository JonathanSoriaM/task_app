import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/tasks/domain/entities/tasks.dart';
import 'package:tasks/tasks/domain/repositories/tesks_repository.dart';
import 'package:tasks/tasks/presentation/providers/tasks_repository_provider.dart';

final tasksProvider = StateNotifierProvider<TasksNotifier, TasksState>((ref) {
  final tasksRepository = ref.watch(tasksRepositoryProvider);
  return TasksNotifier(tasksRepository: tasksRepository);
});

class TasksNotifier extends StateNotifier<TasksState> {
  final TasksRepository tasksRepository;

  TasksNotifier({required this.tasksRepository}) : super(TasksState()) {
    loadTasks();
  }

  Future<bool> createOrUpdateTask(Map<String, dynamic> taskLike) async {
    try {
      final tasks = await tasksRepository.createUpdate(taskLike);
      final isTaskInList = state.tasks.any((element) => element.id == tasks.id);
      if (!isTaskInList) {
        state = state.copyWith(tasks: [...state.tasks, tasks]);
        return true;
      }
      state = state.copyWith(
          tasks: state.tasks
              .map((element) => (element.id == tasks.id) ? tasks : element)
              .toList());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future loadTasks() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    final tasks = await tasksRepository.getTasks('10');
    if (tasks.isEmpty) {
      state = state.copyWith(
        isLoading: false,
      );
      return;
    }

    //state = state.copyWith(isLoading: false, tasks: [...state.tasks, ...tasks]);
    state = state.copyWith(isLoading: false, tasks: [...tasks]);
  }

  Future deleteTask(
    int id,
  ) async {
    final delete = await tasksRepository.deleteTask(id, '10');
    loadTasks();
    return true;
  }
}

class TasksState {
  final bool isLoading;
  final List<Task> tasks;

  TasksState({this.isLoading = false, this.tasks = const []});

  TasksState copyWith({bool? isLoading, List<Task>? tasks}) => TasksState(
      isLoading: isLoading ?? this.isLoading, tasks: tasks ?? this.tasks);
}
