part of 'classes_cubit.dart';

abstract class ClassesEvent {
  const ClassesEvent();
}

class ClassesLoadUser extends ClassesEvent {
  final String userId;

  const ClassesLoadUser({required this.userId});
}

class ClassesUpdateClasses extends ClassesEvent {
  final List<Class> classes;

  ClassesUpdateClasses({required this.classes});
}
