import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tasks/tasks/presentation/providers/tasks_provider.dart';
import 'package:tasks/tasks/presentation/widgets/task_widget.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: const _TasksScreen(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('New'),
        icon: const Icon(Icons.add),
        onPressed: () {
          context.push('/tasks/0');
        },
      ),
    );
  }
}

class _TasksScreen extends ConsumerStatefulWidget {
  const _TasksScreen();

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState {
  @override
  void initState() {
    super.initState();
    ref.read(tasksProvider.notifier).loadTasks();
  }

  // checkbox was tapped
  void checkBoxChanged(bool? value, int id) {
    int complete = 1;
    if (value == false) {
      complete = 0;
    }
    setState(() {});
  }

  // delete task
  void deleteTask(int id) {
    final delete = ref.read(tasksProvider.notifier).deleteTask(
          id,
        );
    if (delete == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);

    return ListView.builder(
        padding: const EdgeInsets.only(bottom: 40),
        itemCount: tasks.tasks.length,
        itemBuilder: (context, index) {
          final task = tasks.tasks[index];
          return TaskWidget(
            id: task.id,
            title: task.title,
            complete: task.is_completed,
            deleteFunction: (context) => deleteTask(task.id),
          );
        });
  }
}
