import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exam/blocs/blocs.dart';
import 'package:exam/models/models.dart';
import 'package:exam/repositories/repositories.dart';

part 'create_class_state.dart';

class CreateClassCubit extends Cubit<CreateClassState> {
  final ClassesRepository _classesRepository;
  final AuthBloc _authBloc;
  final UserRepository _userRepository;

  CreateClassCubit(
      {required AuthBloc authBloc,
      required UserRepository userRepository,
      required ClassesRepository classesRepository})
      : _userRepository = userRepository,
        _authBloc = authBloc,
        _classesRepository = classesRepository,
        super(CreateClassState.initial());

  void reset() {
    emit(CreateClassState.initial());
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: CreateClassStatus.initial));
  }

  void sectionChanged(String value) {
    emit(state.copyWith(section: value, status: CreateClassStatus.initial));
  }

  void subjectChanged(String value) {
    emit(state.copyWith(subject: value, status: CreateClassStatus.initial));
  }

  void roomChanged(String value) {
    emit(state.copyWith(room: value, status: CreateClassStatus.initial));
  }

  Future<void> submit() async {
    emit(state.copyWith(status: CreateClassStatus.submitting));
    try {
      final userId = _authBloc.state.user?.uid;
      final user = await _userRepository.getUserWithId(userId: userId ?? '');
      final classroom = Class(
          id: userId ?? '',
          name: state.name,
          room: state.room,
          section: state.section,
          teachers: [],
          students: [],
          timetable: Timetable.empty,
          questionPapers: []);
      _classesRepository.createClass(
          classroom: classroom, user: user ?? User.empty);
    } catch (err) {
      emit(state.copyWith(
          status: CreateClassStatus.error,
          failure:
              const Failure(message: 'We are unable to create your class')));
    }
  }
}
