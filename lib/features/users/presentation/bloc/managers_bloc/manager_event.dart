part of 'manager_bloc.dart';

@immutable
sealed class ManagerEvent {}

class GetAllManagers extends ManagerEvent {
  final String? excludedId ;

  GetAllManagers({this.excludedId});
}

