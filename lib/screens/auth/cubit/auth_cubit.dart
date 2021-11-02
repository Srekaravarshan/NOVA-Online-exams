import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exam/models/failure_model.dart';
import 'package:exam/repositories/repositories.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState.initial());

  void signUpWithGoogle() async {
    emit(state.copyWith(status: AuthScreenStatus.submitting));
    try {
      print("auth-cubit signin");
      await _authRepository.signUpWithGoogle();
      emit(state.copyWith(status: AuthScreenStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: AuthScreenStatus.error));
    }
  }
}
