import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exam/models/models.dart';
import 'package:exam/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

part 'create_subject_state.dart';

class CreateSubjectCubit extends Cubit<CreateSubjectState> {
  ClassesRepository _classesRepository;

  CreateSubjectCubit({required ClassesRepository classesRepository})
      : _classesRepository = classesRepository,
        super(CreateSubjectState.initial());

  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: CreateSubjectStatus.initial));
  }

  Future<void> submit({required String classId}) async {
    emit(state.copyWith(status: CreateSubjectStatus.submitting));
    try {
      Subject subject =
          Subject(materials: const [], name: state.name, id: const Uuid().v4());
      _classesRepository.createSubject(classId: classId, subject: subject);
      emit(state.copyWith(status: CreateSubjectStatus.success));
    } catch (err) {
      emit(state.copyWith(
          status: CreateSubjectStatus.error,
          failure:
              const Failure(message: 'We are unable to create your subject')));
    }
  }

  void reset() {
    emit(CreateSubjectState.initial());
  }
}
