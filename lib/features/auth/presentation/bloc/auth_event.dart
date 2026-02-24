part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthLogin extends AuthEvent {
  final String email;

  final String password;

  AuthLogin({required this.email, required this.password});
}

class AuthRegister extends AuthEvent {
  final String email;

  final String password;

  final String role;

  final String displayName;

  AuthRegister({
    required this.email,
    required this.password,
    required this.role,
    required this.displayName,
  });
}

class AuthLogout extends AuthEvent {}

class AuthChangePassword extends AuthEvent {
  final String newPassword;

  AuthChangePassword({required this.newPassword});
}


