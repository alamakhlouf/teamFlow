import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../data/profile_model.dart';
import '../../domain/profile_repo.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(ProfileRepo profileRepo) : super(ProfileInitial()) {
    on<GetProfile>((event, emit) async {
      try {
        emit(ProfileLoading());
        final profile = await profileRepo.getProfile();
        emit(ProfileLoaded( profile));
      } on Exception catch (e) {
        debugPrint("There an error during getting profile ${e.toString()}");
        emit(ProfileError());
      }
    });
  }
}
