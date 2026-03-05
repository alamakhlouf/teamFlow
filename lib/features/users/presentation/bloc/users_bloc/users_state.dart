part of 'users_bloc.dart';

@immutable
sealed class UsersState {}

final class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<AppUserModel> users;
  UsersLoaded(this.users);
}

class UsersError extends UsersState {
  final String message;
  UsersError(this.message);
}