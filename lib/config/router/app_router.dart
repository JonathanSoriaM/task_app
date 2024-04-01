import 'package:go_router/go_router.dart';
import 'package:tasks/tasks/presentation/screens/screens.dart';

final appRouter = GoRouter(initialLocation: '/tasks', routes: [
  GoRoute(
    path: '/tasks',
    builder: (context, state) => const TasksScreen(),
  ),
  GoRoute(
      path: '/tasks/:id',
      builder: (context, state) =>
          TaskScreen(taskId: state.pathParameters['id'] ?? 'no-id'))
]);
