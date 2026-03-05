import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:team_flow/features/users/data/manager_model.dart';

import '../../../domain/users_repo.dart';

part 'manager_event.dart';

part 'manager_state.dart';

class ManagerBloc extends Bloc<ManagerEvent, ManagerState> {
  final UsersRepo usersRepo;

  ManagerBloc(this.usersRepo) : super(ManagerInitial()) {
    on<GetAllManagers>((event, emit) async {
      emit(ManagerLoading());
      await emit.forEach<List<ManagerModel>>(
        usersRepo.getAllManagers(excludeUid: event.excludedId),
        onData: (managers) => ManagerLoaded(managers),
        onError: (error, _) => ManagerError(error.toString()),
      );
    });
  }
}
