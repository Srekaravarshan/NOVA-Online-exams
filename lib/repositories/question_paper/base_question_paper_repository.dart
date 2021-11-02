import 'package:exam/models/models.dart';

abstract class BaseQuestionPaperRepository {
  Future<void> createQuestionPaper({required QuestionPaper questionPaper});
  Future<void> updateQuestionPaper({required QuestionPaper questionPaper});
}
