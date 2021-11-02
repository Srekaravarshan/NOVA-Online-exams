import 'package:exam/models/models.dart';

abstract class BaseClassesRepository {
  Stream<List<Class?>> getUserClasses({required String userId});

  Future<void> createClass({required Class classroom, required User user});

  Future<void> createSubject(
      {required String classId, required Subject subject});

  Stream<List<Subject?>> getUserSubjects({required String classId});

  Future<void> updateTimetable(
      {required Timetable timetable, required String classId});

  Future<Class?> getClassWithId({required String classId});

  Future<void> addSet({required String classId, required List questionPapers});
}
