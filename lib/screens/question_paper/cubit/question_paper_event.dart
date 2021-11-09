part of 'question_paper_cubit.dart';

abstract class QuestionPaperEvent {
  const QuestionPaperEvent();
}

class QuestionPaperLoadUser extends QuestionPaperEvent {
  final Class classroom;
  final int setIndex;
  const QuestionPaperLoadUser(
      {required this.setIndex, required this.classroom});
}

class QuestionPaperCreate extends QuestionPaperEvent {
  final String classId;
  final String? qpId;
  final int index;

  const QuestionPaperCreate(
      {required this.classId, this.qpId, required this.index});
}
