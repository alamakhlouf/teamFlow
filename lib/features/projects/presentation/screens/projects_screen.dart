import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_flow/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:team_flow/features/profile/presentation/bloc/profile_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/projects/projects_bloc.dart';
import '../widget/create_project_dialog.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;

    String role = "user";
    if (authState is AuthSuccess) {
      role = authState.appUserModel.role;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
  listener: (context, state) {
    if (state is ProfileLoaded) {
      context.read<ProjectsBloc>().add(LoadProjects(state.profile.role));
    }
  },
  child: BlocBuilder<ProjectsBloc, ProjectsState>(
        builder: (context, state) {
          if (state is ProjectsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProjectsLoaded) {
            final projects = state.projects;

            if (projects.isEmpty) {
              return const Center(child: Text('No projects yet.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: projects.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final project = projects[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/projectDetails',
                      arguments: project,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5F33E1).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(project.description),
                            ],
                          ),
                        ),

                        if (role == "manager")
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  final bloc = context.read<ProjectsBloc>();

                                  showDialog(
                                    context: context,
                                    builder: (_) => BlocProvider.value(
                                      value: bloc,
                                      child: CreateProjectDialog(
                                        project: project,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  context.read<ProjectsBloc>().add(
                                    DeleteProject(project.id),
                                  );
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is ProjectsError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const SizedBox();
        },
      ),
),

      floatingActionButton: role == "manager"
          ? FloatingActionButton(
              onPressed: () {
                final bloc = context.read<ProjectsBloc>();

                showDialog(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: bloc,
                    child: const CreateProjectDialog(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
