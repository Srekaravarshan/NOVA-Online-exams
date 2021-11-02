import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exam/blocs/blocs.dart';
import 'package:exam/models/failure_model.dart';
import 'package:exam/models/user_model.dart';
import 'package:exam/repositories/repositories.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final AuthBloc _authBloc;

  ProfileBloc({
    required UserRepository userRepository,
    required AuthBloc authBloc,
  })  : _userRepository = userRepository,
        _authBloc = authBloc,
        super(ProfileState.initial());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileLoadUser) {
      yield* _mapProfileLoadUserToState(event);
    }
  }

  Stream<ProfileState> _mapProfileLoadUserToState(
    ProfileLoadUser event,
  ) async* {
    yield state.copyWith(status: ProfileStatus.loading);
    print("mapload loading");
    try {
      print(event.userId);
      final user = await _userRepository.getUserWithId(userId: event.userId);
      print(user?.id);
      yield state.copyWith(user: user, status: ProfileStatus.loaded);
      print("mapload loaded");
    } catch (err) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure: const Failure(message: 'We were unable to load this profile.'),
      );
    }
  }
}
