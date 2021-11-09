part of 'assignments_bloc.dart';

abstract class AssignmentsEvent {
  const AssignmentsEvent();
}

class LoadMaterials extends AssignmentsEvent {
  final String classId, subjectId;

  LoadMaterials({required this.classId, required this.subjectId});
}

class CreateAssignment extends AssignmentsEvent {
  final String classId;

  CreateAssignment({required this.classId});
}
