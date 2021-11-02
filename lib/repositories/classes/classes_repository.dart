import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam/config/paths.dart';
import 'package:exam/models/models.dart';
import 'package:exam/repositories/classes/base_classes_repository.dart';

class ClassesRepository extends BaseClassesRepository {
  final FirebaseFirestore _firebaseFirestore;

  ClassesRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createClass(
      {required Class classroom, required User user}) async {
    classroom.teachers.add(user.id);
    await _firebaseFirestore
        .collection(Paths.classes)
        .add(classroom.toDocument());
    user.teachingClasses.add(classroom.id);
    await _firebaseFirestore
        .collection(Paths.users)
        .doc(user.id)
        .update({'teachingClasses': user.teachingClasses});
  }

  @override
  Stream<List<Class>> getUserClasses({required String userId}) {
    return _firebaseFirestore
        .collection(Paths.classes)
        .where('teachers', arrayContains: userId)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Class.fromDocument(doc)!).toList());
  }

  @override
  Future<void> createSubject(
      {required String classId, required Subject subject}) async {
    await _firebaseFirestore
        .collection(Paths.classes)
        .doc(classId)
        .collection(Paths.subjects)
        .add(subject.toDocument());
  }

  @override
  Stream<List<Subject>> getUserSubjects({required String classId}) {
    return _firebaseFirestore
        .collection(Paths.classes)
        .doc(classId)
        .collection(Paths.subjects)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Subject.fromDocument(doc)!).toList());
  }

  @override
  Future<void> updateTimetable(
      {required Timetable timetable, required String classId}) async {
    _firebaseFirestore
        .collection(Paths.classes)
        .doc(classId)
        .update({'timetable': timetable.toDocument()});
  }

  @override
  Future<Class?> getClassWithId({required String classId}) async {
    DocumentSnapshot<Map> doc =
        await _firebaseFirestore.collection(Paths.classes).doc(classId).get();
    return Class.fromDocument(doc);
  }

  @override
  Future<void> addSet(
      {required String classId, required List questionPapers}) async {
    await _firebaseFirestore.collection(Paths.classes).doc(classId).update({
      'questionPapers': questionPapers
          .map((questionPaper) => questionPaper.toDocument())
          .toList()
    });
  }
}
