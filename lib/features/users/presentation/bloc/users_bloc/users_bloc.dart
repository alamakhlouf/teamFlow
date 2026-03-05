import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../auth/data/app_user.dart';
import '../../../domain/users_repo.dart';

part 'users_event.dart';

part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersRepo usersRepo;
  StreamSubscription<List<AppUserModel>>? _usersSubscription;

  UsersBloc(this.usersRepo) : super(UsersInitial()) {
    on<UsersFetch>(_onFetchUsers);
    on<UsersAdd>(_onAddUser);
    on<UsersUpdate>(_onUpdateUser);
    on<UsersDelete>(_onDeleteUser);
  }

  void _onFetchUsers(UsersFetch event, Emitter<UsersState> emit) async {
    emit(UsersLoading());

    await emit.forEach<List<AppUserModel>>(
      usersRepo.getUsers(),
      onData: (users) => UsersLoaded(users),
      onError: (error, _) => UsersError(error.toString()),
    );
  }

  Future<void> _onAddUser(UsersAdd event, Emitter<UsersState> emit) async {
    emit(UsersLoading());
    try {
      usersRepo.registerWithEmailAndPassword(
        event.appUserModel,
        event.password,
      );
    } catch (e) {
      debugPrint("There an error during adding user ${e.toString()}");
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(
    UsersUpdate event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    try {
      usersRepo.updateUser(event.appUserModel);
      print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAa");
    } catch (e) {
      debugPrint("There an error during adding user ${e.toString()}");
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onDeleteUser(
    UsersDelete event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    try {
      usersRepo.deleteUser(event.userId);
    } catch (e) {
      debugPrint("There an error during adding user ${e.toString()}");
      emit(UsersError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _usersSubscription?.cancel();
    return super.close();
  }
}
