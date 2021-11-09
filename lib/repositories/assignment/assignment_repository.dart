import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam/config/paths.dart';
import 'package:exam/models/assignment_model.dart';
import 'package:exam/models/models.dart';
import 'package:exam/repositories/repositories.dart';

class AssignmentRepository extends BaseAssignmentRepository {
  final FirebaseFirestore _firebaseFirestore;

  AssignmentRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createAssignment(
      {required Assignment assignment,
      required String classId,
      required String subjectId}) async {
    await _firebaseFirestore
        .collection(Paths.classes)
        .doc(classId)
        .collection(Paths.subjects)
        .doc(subjectId)
        .update({
      'materials': FieldValue.arrayUnion([assignment.id])
    });
    await _firebaseFirestore
        .collection(Paths.materials)
        .doc(assignment.id)
        .set(assignment.toDocument());
  }

  Future<List> getAssignmentIds(
      {required String classId, required String subjectId}) async {
    Subject subject = Subject.fromDocument(await _firebaseFirestore
            .collection(Paths.classes)
            .doc(classId)
            .collection(Paths.subjects)
            .doc(subjectId)
            .get()) ??
        Subject.empty;
    return subject.materials;
  }

  Future<Assignment> getAssignment({required String assignmentId}) async {
    return Assignment.fromDocument(await _firebaseFirestore
        .collection(Paths.materials)
        .doc(assignmentId)
        .get());
  }
}
