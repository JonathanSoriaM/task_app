import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks/tasks/domain/domain.dart';
import 'package:tasks/tasks/presentation/providers/task_form_provider.dart';
import 'package:tasks/tasks/presentation/providers/task_provider.dart';
import 'package:tasks/tasks/presentation/widgets/custom_task_field.dart';
import 'package:tasks/tasks/presentation/widgets/loading_screen.dart';

class TaskScreen extends ConsumerWidget {
  final String taskId;

  const TaskScreen({super.key, required this.taskId});
  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Exito')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskProvider(int.parse(taskId)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task'),
      ),
      body: taskState.isLoading
          ? const FullScreenLoader()
          : _TaskView(task: taskState.task!),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (taskState.task == null) return;
          ref
              .read(taskFormProvider(taskState.task!).notifier)
              .onFormSubmit()
              .then((value) {
            if (!value) return;
            showSnackBar(context);
          });
        },
        child: const Icon(Icons.save_as_outlined),
      ),
    );
  }
}

class _TaskView extends ConsumerWidget {
  final Task task;
  const _TaskView({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [_TaskData(task: task)],
    );
  }
}

class _TaskData extends ConsumerWidget {
  final Task task;
  const _TaskData({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskForm = ref.watch(taskFormProvider(task));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Container(
            height: 50,
          ),
          SwitchListTile.adaptive(
              title: const Text(
                'Finalizar',
                style: TextStyle(color: Colors.black),
              ),
              value: taskForm.is_completed == 0 ? false : true,
              onChanged: (value) => ref
                  .read(taskFormProvider(task).notifier)
                  .onCompletedChanged(value == false ? 0 : 1)),
          CustomTaskField(
            isBottomField: true,
            keyboardType: TextInputType.multiline,
            label: 'Title',
            initialValue: taskForm.title.value,
            onChanged: ref.read(taskFormProvider(task).notifier).ontitleChanged,
            errorMessage: taskForm.title.errorMessage,
          ),
          CustomTaskField(
            isBottomField: true,
            keyboardType: TextInputType.multiline,
            label: 'Description',
            onChanged:
                ref.read(taskFormProvider(task).notifier).onDescriptionChanged,
          ),
          CustomTaskField(
            isBottomField: true,
            keyboardType: TextInputType.multiline,
            label: 'Comments',
            initialValue: taskForm.comments,
            onChanged:
                ref.read(taskFormProvider(task).notifier).onCommentsChanged,
          ),
          CustomTaskField(
            isBottomField: true,
            keyboardType: TextInputType.multiline,
            label: 'Tags',
            initialValue: taskForm.tags,
            onChanged: ref.read(taskFormProvider(task).notifier).onTagsChanged,
          ),
          CustomTaskField(
            isBottomField: true,
            keyboardType: TextInputType.datetime,
            label: 'Due Date',
            initialValue: taskForm.due_date,
            onChanged:
                ref.read(taskFormProvider(task).notifier).onDueDateChanged,
          ),
        ],
      ),
    );
  }
}
