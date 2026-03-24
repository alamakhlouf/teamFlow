import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/project_model.dart';
import '../bloc/projects/projects_bloc.dart';

class CreateProjectDialog extends StatefulWidget {
  final ProjectModel? project;

  const CreateProjectDialog({this.project, super.key});

  @override
  State<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<CreateProjectDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    if (widget.project != null) {
      _nameController.text = widget.project!.name;
      _descController.text = widget.project!.description;
    }

    _nameController.addListener(_validate);
    _descController.addListener(_validate);
  }

  void _validate() {
    final isValid =
        _nameController.text.trim().isNotEmpty &&
        _descController.text.trim().isNotEmpty;

    setState(() {
      _isButtonEnabled = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.project != null;

    return AlertDialog(
      title: Text(isEdit ? "Edit Project" : "Create Project"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Project Name"),
          ),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(labelText: "Description"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        BlocConsumer<ProjectsBloc, ProjectsState>(
          listener: (context, state) {
            if (state is ProjectsLoaded) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is ProjectsLoading) {
              return const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }

            return ElevatedButton(
              onPressed: _isButtonEnabled
                  ? () {
                      final project = ProjectModel(
                        id: isEdit ? widget.project!.id : '',
                        name: _nameController.text.trim(),
                        description: _descController.text.trim(),
                        managerId: isEdit
                            ? widget.project!.managerId
                            : FirebaseAuth.instance.currentUser!.uid,
                        // set in repo
                        employeeIds: [],
                        createdAt: DateTime.now(),
                      );

                      if (isEdit) {
                        context.read<ProjectsBloc>().add(
                          UpdateProject(project),
                        );
                      } else {
                        context.read<ProjectsBloc>().add(
                          CreateProject(project),
                        );
                      }
                    }
                  : null,
              child: Text(isEdit ? "Update" : "Create"),
            );
          },
        ),
      ],
    );
  }
}
