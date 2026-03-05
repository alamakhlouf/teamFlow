part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}
final class AuthUnauthenticated extends AuthState {}

final class AuthSuccess extends AuthState {
  final AppUserModel appUserModel;

  AuthSuccess(this.appUserModel);
}

final class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
