part of 'classroom_bloc.dart';

abstract class ClassroomEvent {
  const ClassroomEvent();
}

class ClassroomLoadClass extends ClassroomEvent {
  final String classId;

  ClassroomLoadClass({required this.classId});
}

class ClassroomUpdateSubjects extends ClassroomEvent {
  final List<Subject> subjects;

  ClassroomUpdateSubjects({required this.subjects});
}
