import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exam/models/models.dart';
import 'package:exam/repositories/repositories.dart';

part 'classroom_event.dart';
part 'classroom_state.dart';

class ClassroomBloc extends Bloc<ClassroomEvent, ClassroomState> {
  StreamSubscription<List<Subject>>? _subjectSubscription;
  final ClassesRepository _classesRepository;

  ClassroomBloc({required ClassesRepository classesRepository})
      : _classesRepository = classesRepository,
        super(ClassroomState.initial());

  @override
  Future<void> close() {
    _subjectSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<ClassroomState> mapEventToState(
    ClassroomEvent event,
  ) async* {
    if (event is ClassroomLoadClass) {
      yield* _mapClassroomLoadClassToState(event);
    } else if (event is ClassroomUpdateSubjects) {
      yield* _mapClassroomUpdateSubjectsToState(event);
    }
  }

  Stream<ClassroomState> _mapClassroomLoadClassToState(
      ClassroomLoadClass event) async* {
    yield state.copyWith(status: ClassroomStatus.loading);
    try {
      final classroom =
          await _classesRepository.getClassWithId(classId: event.classId);
      _subjectSubscription?.cancel();
      _subjectSubscription = _classesRepository
          .getUserSubjects(classId: event.classId)
          .listen((subjects) {
        add(ClassroomUpdateSubjects(subjects: subjects));
      });
      yield state.copyWith(
          classroom: classroom, status: ClassroomStatus.loaded);
    } catch (err) {
      print(err);
      yield state.copyWith(
        status: ClassroomStatus.error,
        failure: const Failure(message: 'We were unable to load class.'),
      );
    }
  }

  Stream<ClassroomState> _mapClassroomUpdateSubjectsToState(
      ClassroomUpdateSubjects event) async* {
    yield state.copyWith(subjects: event.subjects);
  }
}
