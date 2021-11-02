part of 'profile_bloc.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class ProfileLoadUser extends ProfileEvent {
  final String userId;

  const ProfileLoadUser({required this.userId});
}
