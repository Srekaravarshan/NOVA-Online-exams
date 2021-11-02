import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exam/models/models.dart';
import 'package:exam/repositories/repositories.dart';

part 'timetable_subject_state.dart';

class TimetableSubjectCubit extends Cubit<TimetableSubjectState> {
  ClassesRepository _classesRepository;

  TimetableSubjectCubit({required ClassesRepository classesRepository})
      : _classesRepository = classesRepository,
        super(TimetableSubjectState.initial());

  void setChanged(String value) {
    emit(state.copyWith(set: value, status: TimetableSubjectStatus.initial));
  }

  Future<void> addSet({required Class classroom}) async {
    emit(state.copyWith(status: TimetableSubjectStatus.submitting));
    try {
      classroom.questionPapers.add(QuestionPaper(
          set: state.set,
          mode: 'mcq',
          sections: [],
          status: 'initial',
          id: ''));
      print(classroom.questionPapers.length);
      await _classesRepository.addSet(
          classId: classroom.id, questionPapers: classroom.questionPapers);
      emit(state.copyWith(status: TimetableSubjectStatus.success));
    } catch (err) {
      print(err);
      emit(state.copyWith(
          status: TimetableSubjectStatus.error,
          failure: const Failure(message: 'We are unable to create set')));
    }
  }
}
