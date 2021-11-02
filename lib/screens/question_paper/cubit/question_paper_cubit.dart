import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exam/models/models.dart';
import 'package:exam/repositories/repositories.dart';

part 'question_paper_event.dart';
part 'question_paper_state.dart';

class QuestionPaperCubit extends Bloc<QuestionPaperEvent, QuestionPaperState> {
  QuestionPaperRepository _questionPaperRepository;

  QuestionPaperCubit({required QuestionPaperRepository questionPaperRepository})
      : _questionPaperRepository = questionPaperRepository,
        super(QuestionPaperState.initial());

  @override
  Stream<QuestionPaperState> mapEventToState(
    QuestionPaperEvent event,
  ) async* {
    if (event is QuestionPaperLoadUser) {
      yield* _mapQuestionPaperLoadUserToState(event);
    }
  }

  Stream<QuestionPaperState> _mapQuestionPaperLoadUserToState(
    QuestionPaperLoadUser event,
  ) async* {
    yield state.copyWith(status: QuestionPaperStatus.loading);
    try {
      yield state.copyWith(status: QuestionPaperStatus.loaded);
    } catch (err) {
      yield state.copyWith(
        status: QuestionPaperStatus.error,
        failure:
            const Failure(message: 'We were unable to load question paper.'),
      );
    }
  }

  void questionChanged(
      {required String value,
      required int sectionIndex,
      required int questionIndex}) {
    state.questionPaper.sections[sectionIndex].questions[questionIndex].title =
        value;
    // emit(state.copyWith(sections: sections, status: QuestionPaperStatus.initial));
  }

  Future<void> create(String set, String mode) async {
    await _questionPaperRepository.createQuestionPaper(
        questionPaper: QuestionPaper(
            set: set,
            sections: state.questionPaper.sections,
            mode: mode,
            status: 'initial',
            id: ''));
  }

  Future<void> save() async {
    await _questionPaperRepository.updateQuestionPaper(
        questionPaper: state.questionPaper);
  }
}
