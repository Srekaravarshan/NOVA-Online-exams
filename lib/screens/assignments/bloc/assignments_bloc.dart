import 'dart:async';

import 'package:exam/models/models.dart';
import 'package:exam/repositories/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'assignments_event.dart';
part 'assignments_state.dart';

class AssignmentsBloc extends Bloc<AssignmentsEvent, AssignmentsState> {
  final StorageRepository _storageRepository;
  final AssignmentRepository _assignmentRepository;

  AssignmentsBloc(
      {required StorageRepository storageRepository,
      required AssignmentRepository assignmentRepository})
      : _assignmentRepository = assignmentRepository,
        _storageRepository = storageRepository,
        super(AssignmentsState.initial());

  @override
  Stream<AssignmentsState> mapEventToState(
    AssignmentsEvent event,
  ) async* {
    if (event is LoadMaterials) {
      yield* _mapLoadMaterialsToState(event);
    }
  }

  Stream<AssignmentsState> _mapLoadMaterialsToState(
      LoadMaterials event) async* {
    yield state.copyWith(status: AssignmentsStatus.loading);

    List assignments = [];
    print('assignments');

    List ids = await _assignmentRepository.getAssignmentIds(
        classId: event.classId, subjectId: event.subjectId);
    for (var id in ids) {
      Assignment assignment =
          await _assignmentRepository.getAssignment(assignmentId: id);
      List<FirebaseFile> files =
          await _storageRepository.listAll('materials/$id/');
      print(assignment.title);
      print(files.length);
      assignment = assignment.copyWith(materials: files);
      assignments.add(assignment);
    }

    print(assignments.length);

    yield state.copyWith(
        assignments: assignments, status: AssignmentsStatus.loaded);
  }
}
