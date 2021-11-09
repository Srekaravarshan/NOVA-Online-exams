import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exam/models/models.dart';
import 'package:exam/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

part 'question_paper_event.dart';
part 'question_paper_state.dart';

class QuestionPaperBloc extends Bloc<QuestionPaperEvent, QuestionPaperState> {
  QuestionPaperRepository _questionPaperRepository;

  QuestionPaperBloc({required QuestionPaperRepository questionPaperRepository})
      : _questionPaperRepository = questionPaperRepository,
        super(QuestionPaperState.initial());

  @override
  Stream<QuestionPaperState> mapEventToState(
    QuestionPaperEvent event,
  ) async* {
    if (event is QuestionPaperLoadUser) {
      yield* _mapQuestionPaperLoadQuestionPaperToState(event);
    } else if (event is QuestionPaperCreate) {
      yield* _mapQuestionPaperCreateToState(event);
    }
  }

  Stream<QuestionPaperState> _mapQuestionPaperLoadQuestionPaperToState(
    QuestionPaperLoadUser event,
  ) async* {
    yield state.copyWith(status: QuestionPaperStatus.loading);
    try {
      String qpId = const Uuid().v4();
      if (event.classroom.questionPapers[event.setIndex].id == null ||
          event.classroom.questionPapers[event.setIndex].id.trim() == '') {
        add(QuestionPaperCreate(
            classId: event.classroom.id, qpId: qpId, index: event.setIndex));
      }
      QuestionPaper questionPaper =
          await _questionPaperRepository.getQuestionPaper(id: qpId);
      yield state.copyWith(
          id: qpId,
          sections: questionPaper.sections,
          set: questionPaper.set,
          mode: questionPaper.mode,
          qpStatus: questionPaper.status,
          status: QuestionPaperStatus.loaded);
    } catch (err) {
      print(err.toString());
      yield state.copyWith(
        status: QuestionPaperStatus.error,
        failure:
            const Failure(message: 'We were unable to load question paper.'),
      );
    }
  }

  Stream<QuestionPaperState> questionChanged(
      {required String value,
      required int sectionIndex,
      required int questionIndex}) async* {
    (state.sections[sectionIndex].questions[questionIndex].title = value);
    // emit(state.copyWith(sections: sections, status: QuestionPaperStatus.initial));
  }

  Stream<QuestionPaperState> _mapQuestionPaperCreateToState(
      QuestionPaperCreate event) async* {
    yield (state.copyWith(id: event.qpId ?? const Uuid().v4()));
    await _questionPaperRepository.createQuestionPaper(
        questionPaper: QuestionPaper(
            id: state.id,
            set: state.set,
            mode: state.mode,
            sections: state.sections,
            status: state.qpStatus),
        classId: event.classId,
        index: event.index);
  }

  Future<void> save() async {
    await _questionPaperRepository.updateQuestionPaper(
        questionPaper: QuestionPaper(
            id: state.id,
            set: state.set,
            mode: state.mode,
            sections: state.sections,
            status: state.qpStatus));
  }
}
