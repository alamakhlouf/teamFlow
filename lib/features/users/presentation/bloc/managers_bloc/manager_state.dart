part of 'manager_bloc.dart';

@immutable
sealed class ManagerState {}

final class ManagerInitial extends ManagerState {}

final class ManagerLoading extends ManagerState {}

final class ManagerLoaded extends ManagerState {
  final List<ManagerModel> managersList;

  ManagerLoaded(this.managersList);
}

final class ManagerError extends ManagerState {
  final String error;

  ManagerError(this.error);
}
