import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class TaskWidget extends ConsumerWidget {
  final int id;
  final String title;
  final int complete;
  final String? date;

  Function(BuildContext)? deleteFunction;

  TaskWidget(
      {super.key,
      required this.id,
      required this.title,
      required this.complete,
      required this.deleteFunction,
      this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: deleteFunction,
                icon: Icons.delete,
                backgroundColor: Colors.red.shade300,
                borderRadius: BorderRadius.circular(12),
              )
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () => context.push('/tasks/$id'),
              title: Text(
                title,
                style: TextStyle(
                  decoration: complete == 1
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          )),
    );
  }
}
