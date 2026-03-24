import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../users/domain/users_repo.dart';
import '../../../users/presentation/bloc/users_bloc/users_bloc.dart';
import '../../data/task_model.dart';
import '../bloc/tasks/tasks_bloc.dart';

class TaskDialog extends StatefulWidget {
  final String projectId;
  final TaskModel? task;

  const TaskDialog({super.key, required this.projectId, this.task});

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();

  String? selectedUserId;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _title.text = widget.task!.title;
      _desc.text = widget.task!.description;
      selectedUserId = widget.task!.assignedTo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;

    return AlertDialog(
      title: Text(isEdit ? "Edit Task" : "Create Task"),
      content: MultiBlocProvider(
        providers: [

          BlocProvider( create: (context) => UsersBloc(UsersRepo())..add(UsersFetch())),
          BlocProvider( create: (context) => TasksBloc()),
        ], child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _title, decoration: const InputDecoration(labelText: "Title")),
          TextField(controller: _desc, decoration: const InputDecoration(labelText: "Description")),

          BlocBuilder<UsersBloc, UsersState>(
            builder: (context, state) {
              if (state is UsersLoaded) {
                return DropdownButtonFormField<String>(
                  value: selectedUserId,
                  items: state.users
                      .map((u) => DropdownMenuItem(
                    value: u.uid,
                    child: Text(u.displayName),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedUserId = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: "Assign User"),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        BlocProvider(
          create: (context) => TasksBloc(),
          child: BlocBuilder<TasksBloc, TasksState>(
            builder: (context, state) {
              return ElevatedButton(
            onPressed: () {
              final task = TaskModel(
                id: isEdit ? widget.task!.id : '',
                title: _title.text.trim(),
                description: _desc.text.trim(),
                assignedTo: selectedUserId,
                status: "todo", projectId: widget.projectId, createdAt: DateTime.now(),
              );

              if (isEdit) {
                context.read<TasksBloc>().add(
                  TasksUpdate(widget.projectId, task),
                );
              } else {
                context.read<TasksBloc>().add(
                  AddTask(widget.projectId, task),
                );
              }

              Navigator.pop(context);
            },
            child: Text(isEdit ? "Update" : "Create"),
          );
            },
          ),
        ),
      ],
    );
  }
}