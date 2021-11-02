part of 'auth_cubit.dart';

enum AuthScreenStatus { initial, submitting, success, error }

class AuthState extends Equatable {
  final AuthScreenStatus status;
  final Failure failure;

  const AuthState({required this.status, required this.failure});

  factory AuthState.initial() {
    return const AuthState(
        status: AuthScreenStatus.initial, failure: Failure());
  }

  AuthState copyWith({
    AuthScreenStatus? status,
    Failure? failure,
  }) {
    if ((status == null || identical(status, this.status)) &&
        (failure == null || identical(failure, this.failure))) {
      return this;
    }

    return AuthState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [];
}
