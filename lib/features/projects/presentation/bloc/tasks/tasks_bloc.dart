import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../data/task_model.dart';
import '../../../domain/tasks_repo.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepo _tasksRepo = TasksRepo();

  StreamSubscription<List<TaskModel>>? _tasksSubscription;

  TasksBloc() : super(TasksInitial()) {

    on<LoadTasks>((event, emit) async {
      emit(TasksLoading());

      await _tasksSubscription?.cancel();

      _tasksSubscription = _tasksRepo
          .getTasks(event.projectId)
          .listen((tasks) {
        add(TasksUpdated(tasks));
      });
    });

    on<TasksUpdated>((event, emit) {
      emit(TasksLoaded(event.tasks));
    });

    on<AddTask>((event, emit) async {
      try {
        await _tasksRepo.addTaskToProject(event.projectId, event.task);
      } catch (e) {
        emit(TasksError(e.toString()));
      }
    });
    on<TasksUpdate>((event, emit) async {
      try {
        await _tasksRepo.updateTask(event.projectId, event.task);
      } catch (e) {
        emit(TasksError(e.toString()));
      }
    });

    on<AssignTask>((event, emit) async {
      try {
        await _tasksRepo.assignTaskToEmployee(
          event.projectId,
          event.taskId,
          event.employeeId,
        );
      } catch (e) {
        emit(TasksError(e.toString()));
      }
    });

    on<UpdateTaskStatus>((event, emit) async {
      try {
        await _tasksRepo.updateTaskStatus(
          event.projectId,
          event.taskId,
          event.status,
        );
      } catch (e) {
        emit(TasksError(e.toString()));
      }
    });

    on<DeleteTask>((event, emit) async {
      try {
        await _tasksRepo.deleteTask(
          event.projectId,
          event.taskId,
        );
      } catch (e) {
        emit(TasksError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}