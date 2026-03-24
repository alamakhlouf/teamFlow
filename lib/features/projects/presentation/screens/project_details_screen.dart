import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/project_model.dart';
import '../../data/task_model.dart';
import '../bloc/tasks/tasks_bloc.dart';
import '../widget/task_dialog.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;

    String role = "user";
    String uid = "";

    if (authState is AuthSuccess) {
      role = authState.appUserModel.role;
      uid = authState.appUserModel.uid;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(project.description),
              ],
            ),
          ),

          Expanded(
            child: BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                if (state is TasksLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TasksLoaded) {
                  final tasks = state.tasks;

                  if (tasks.isEmpty) {
                    return const Center(
                      child: Text("No tasks yet. Create one 🚀"),
                    );
                  }

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      final isAssignedToMe =
                          task.assignedTo == uid;

                      return ListTile(
                        title: Text(task.title),
                        subtitle: Text(task.description),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButton<String>(
                              value: task.status,
                              items: ["todo", "in_progress", "done"]
                                  .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                if (role == "admin" ||
                                    role == "manager" ||
                                    isAssignedToMe) {
                                  context.read<TasksBloc>().add(
                                    UpdateTaskStatus(
                                      project.id,
                                      task.id,
                                      value!,
                                    ),
                                  );
                                }
                              },
                            ),

                            if (role == "admin" || role == "manager")
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.green),
                                onPressed: () {
                                  _openTaskDialog(context, project.id, task);
                                },
                              ),

                            if (role == "admin" || role == "manager")
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  context.read<TasksBloc>().add(
                                    DeleteTask(project.id, task.id),
                                  );
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is TasksError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),

      floatingActionButton: (role == "admin" || role == "manager")
          ? FloatingActionButton(
        onPressed: () {
          _openTaskDialog(context, project.id, null);
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  void _openTaskDialog(BuildContext context, String projectId, TaskModel? task) {
    showDialog(
      context: context,
      builder: (_) => TaskDialog(
        projectId: projectId,
        task: task,
      ),
    );
  }
}