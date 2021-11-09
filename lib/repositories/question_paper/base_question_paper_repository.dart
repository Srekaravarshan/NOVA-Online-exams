import 'package:exam/models/models.dart';

abstract class BaseQuestionPaperRepository {
  Future<QuestionPaper> getQuestionPaper({required String id});
  Future<void> createQuestionPaper(
      {required QuestionPaper questionPaper,
      required String classId,
      required int index});
  Future<void> updateQuestionPaper({required QuestionPaper questionPaper});
}
