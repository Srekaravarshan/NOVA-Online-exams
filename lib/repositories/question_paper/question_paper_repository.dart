import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam/config/paths.dart';
import 'package:exam/models/models.dart';
import 'package:exam/models/question_paper_model.dart';
import 'package:exam/repositories/repositories.dart';

class QuestionPaperRepository extends BaseQuestionPaperRepository {
  final FirebaseFirestore _firebaseFirestore;

  QuestionPaperRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createQuestionPaper(
      {required QuestionPaper questionPaper,
      required String classId,
      required int index}) async {
    Class classroom = Class.fromDocument(await _firebaseFirestore
            .collection(Paths.classes)
            .doc(classId)
            .get()) ??
        Class.empty;
    classroom.questionPapers[index] =
        questionPaper.copyWith(id: questionPaper.id);
    await _firebaseFirestore.collection(Paths.classes).doc(classId).update({
      'questionPapers': classroom.questionPapers
          .map((questionPaper) => questionPaper.toDocument())
          .toList()
    });
    await _firebaseFirestore
        .collection(Paths.questionPapers)
        .doc(questionPaper.id)
        .set(questionPaper.toDocument());
  }

  @override
  Future<void> updateQuestionPaper(
      {required QuestionPaper questionPaper}) async {
    await _firebaseFirestore
        .collection(Paths.questionPapers)
        .doc(questionPaper.id)
        .update({});
  }

  @override
  Future<QuestionPaper> getQuestionPaper({required String id}) async {
    DocumentSnapshot<Map> doc =
        await _firebaseFirestore.collection(Paths.questionPapers).doc(id).get();
    return QuestionPaper.fromDocument(doc) ?? QuestionPaper.empty;
  }
}
