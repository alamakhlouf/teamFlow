import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:team_flow/features/auth/data/app_user.dart';
import 'package:team_flow/features/auth/domain/auth_repo.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _authRepo = AuthRepo();

  AuthBloc() : super(AuthInitial()) {
    on<AuthLogin>((event, emit) async {
      emit(AuthLoading());
      try {
        final AppUserModel user = await _authRepo.signInWithEmailAndPassword(
          event.email,
          event.password,
        );
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthRegister>((event, emit) async {
      emit(AuthLoading());
      try {
        final AppUserModel user = await _authRepo.registerWithEmailAndPassword(
          event.email,
          event.password,
          event.displayName,
          event.role,
        );
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    on<AuthLogout>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepo.signOut();
        emit(AuthSuccess(null));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthChangePassword>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepo.changePassword(event.newPassword);
        emit(AuthSuccess(null));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
