import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:exam/models/models.dart';
import 'package:exam/repositories/repositories.dart';

part 'classes_event.dart';
part 'classes_state.dart';

class ClassesBloc extends Bloc<ClassesEvent, ClassesState> {
  final ClassesRepository _classesRepository;

  StreamSubscription<List<Class>>? _classesSubscription;

  ClassesBloc(
      {required UserRepository userRepository,
      required ClassesRepository classesRepository})
      : _classesRepository = classesRepository,
        super(ClassesState.initial());

  @override
  Future<void> close() {
    _classesSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<ClassesState> mapEventToState(
    ClassesEvent event,
  ) async* {
    if (event is ClassesLoadUser) {
      yield* _mapClassesLoadUserToState(event);
    } else if (event is ClassesUpdateClasses) {
      yield* _mapClassesUpdateClassesToState(event);
    }
  }

  Stream<ClassesState> _mapClassesUpdateClassesToState(
    ClassesUpdateClasses event,
  ) async* {
    yield state.copyWith(classes: event.classes);
  }

  Stream<ClassesState> _mapClassesLoadUserToState(
      ClassesLoadUser event) async* {
    yield state.copyWith(status: ClassStatus.loading);
    try {
      _classesSubscription?.cancel();
      _classesSubscription = _classesRepository
          .getUserClasses(userId: event.userId)
          .listen((classes) async {
        add(ClassesUpdateClasses(classes: classes));
      });
      yield state.copyWith(status: ClassStatus.loaded);
    } catch (err) {
      print(err);
      yield state.copyWith(
        status: ClassStatus.error,
        failure: const Failure(message: 'We were unable to load classes.'),
      );
    }
  }
}
