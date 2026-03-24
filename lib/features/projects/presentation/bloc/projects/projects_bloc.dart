import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../data/project_model.dart';
import '../../../domain/projects_repo.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final ProjectsRepo _projectsRepo = ProjectsRepo();

  StreamSubscription<List<ProjectModel>>? _projectsSubscription;

  ProjectsBloc() : super(ProjectsInitial()) {

    on<LoadProjects>((event, emit) async {
      emit(ProjectsLoading());

      await _projectsSubscription?.cancel();

      _projectsSubscription = _projectsRepo
          .getProjectsByRole(event.role)
          .listen((projects) {
        add(ProjectsUpdated(projects));
      });
    });

    on<ProjectsUpdated>((event, emit) {
      emit(ProjectsLoaded(event.projects));
    });

    on<CreateProject>((event, emit) async {
      try {
        await _projectsRepo.createProject(event.project);
      } catch (e) {
        emit(ProjectsError(e.toString()));
      }
    });

    on<UpdateProject>((event, emit) async {
      try {
        await _projectsRepo.updateProject(event.project);
      } catch (e) {
        emit(ProjectsError(e.toString()));
      }
    });

    on<DeleteProject>((event, emit) async {
      try {
        await _projectsRepo.deleteProject(event.projectId);
      } catch (e) {
        emit(ProjectsError(e.toString()));
      }
    });

    on<AddEmployeeToProject>((event, emit) async {
      try {
        await _projectsRepo.addEmployeeToProject(
          event.projectId,
          event.employeeId,
        );
      } catch (e) {
        emit(ProjectsError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _projectsSubscription?.cancel();
    return super.close();
  }
}