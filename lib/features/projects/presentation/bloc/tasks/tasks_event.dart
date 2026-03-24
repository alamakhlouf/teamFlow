part of 'tasks_bloc.dart';

abstract class TasksEvent {}

class LoadTasks extends TasksEvent {
  final String projectId;

  LoadTasks(this.projectId);
}

class TasksUpdated extends TasksEvent {
  final List<TaskModel> tasks;

  TasksUpdated(this.tasks);
}

class TasksUpdate extends TasksEvent {
  final String projectId;
  final TaskModel task;

  TasksUpdate(this.projectId, this.task);
}


class AddTask extends TasksEvent {
  final String projectId;
  final TaskModel task;

  AddTask(this.projectId, this.task);
}

class AssignTask extends TasksEvent {
  final String projectId;
  final String taskId;
  final String employeeId;

  AssignTask(this.projectId, this.taskId, this.employeeId);
}

class UpdateTaskStatus extends TasksEvent {
  final String projectId;
  final String taskId;
  final String status;

  UpdateTaskStatus(this.projectId, this.taskId, this.status);
}

class DeleteTask extends TasksEvent {
  final String projectId;
  final String taskId;

  DeleteTask(this.projectId, this.taskId);
}