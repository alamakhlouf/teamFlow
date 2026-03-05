part of 'users_bloc.dart';

@immutable
sealed class UsersEvent {}

class UsersFetch extends UsersEvent {}

class UsersAdd extends UsersEvent {
  final AppUserModel appUserModel;
  final String password;
  UsersAdd(this.appUserModel,this.password);
}

class UsersUpdate extends UsersEvent {
  final AppUserModel appUserModel;
  UsersUpdate(this.appUserModel);
}

class UsersDelete extends UsersEvent {
  final String userId;
  UsersDelete(this.userId);
}
