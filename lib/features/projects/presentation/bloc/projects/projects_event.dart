part of 'projects_bloc.dart';

abstract class ProjectsEvent {}

class LoadProjects extends ProjectsEvent {
  final String role;

  LoadProjects(this.role);
}

class ProjectsUpdated extends ProjectsEvent {
  final List<ProjectModel> projects;

  ProjectsUpdated(this.projects);
}

class CreateProject extends ProjectsEvent {
  final ProjectModel project;

  CreateProject(this.project);
}

class UpdateProject extends ProjectsEvent {
  final ProjectModel project;

  UpdateProject(this.project);
}

class DeleteProject extends ProjectsEvent {
  final String projectId;

  DeleteProject(this.projectId);
}

class AddEmployeeToProject extends ProjectsEvent {
  final String projectId;
  final String employeeId;

  AddEmployeeToProject(this.projectId, this.employeeId);
}