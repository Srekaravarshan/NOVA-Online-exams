import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam/config/paths.dart';
import 'package:exam/models/question_paper_model.dart';
import 'package:exam/repositories/repositories.dart';

class QuestionPaperRepository extends BaseQuestionPaperRepository {
  final FirebaseFirestore _firebaseFirestore;

  QuestionPaperRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createQuestionPaper(
      {required QuestionPaper questionPaper}) async {
    await _firebaseFirestore
        .collection(Paths.questionPapers)
        .add(questionPaper.toDocument());
  }

  @override
  Future<void> updateQuestionPaper(
      {required QuestionPaper questionPaper}) async {
    await _firebaseFirestore
        .collection(Paths.questionPapers)
        .doc(questionPaper.id)
        .update({});
  }
}
