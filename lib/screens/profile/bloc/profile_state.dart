part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState {
  final User user;
  final ProfileStatus status;
  final Failure failure;

  const ProfileState(
      {required this.user, required this.status, required this.failure});

  factory ProfileState.initial() {
    return ProfileState(
      user: User.empty,
      status: ProfileStatus.initial,
      failure: const Failure(),
    );
  }

  ProfileState copyWith({
    User? user,
    ProfileStatus? status,
    Failure? failure,
  }) {
    if ((user == null || identical(user, this.user)) &&
        (status == null || identical(status, this.status)) &&
        (failure == null || identical(failure, this.failure))) {
      return this;
    }

    return ProfileState(
      user: user ?? this.user,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
