import 'package:exam/models/models.dart';

abstract class BaseAssignmentRepository {
  Future<void> createAssignment(
      {required Assignment assignment,
      required String classId,
      required String subjectId});
}
