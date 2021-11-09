import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exam/models/models.dart';
import 'package:exam/repositories/repositories.dart';
import 'package:file_picker/file_picker.dart';

part 'create_assignment_state.dart';

class CreateAssignmentCubit extends Cubit<CreateAssignmentState> {
  final StorageRepository _storageRepository;
  final AssignmentRepository _assignmentRepository;

  CreateAssignmentCubit(
      {required StorageRepository storageRepository,
      required AssignmentRepository assignmentRepository})
      : _assignmentRepository = assignmentRepository,
        _storageRepository = storageRepository,
        super(CreateAssignmentState.initial());

  void titleChanged(String value) {
    emit(state.copyWith(title: value, status: CreateAssignmentStatus.initial));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(
        description: value, status: CreateAssignmentStatus.initial));
  }

  void reset() {
    emit(CreateAssignmentState.initial());
  }

  Future<void> pickFiles({required String classId}) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      // emit(state.copyWith(status: CreateAssignmentStatus.submitting));
      List<File> files = result.paths.map((path) => File(path!)).toList();
      emit(state.copyWith(fileUrls: files));
      // files.forEach((file) {
      //   _storageRepository.uploadMaterial(
      //       file: file, classId: classId, assignmentId: getAssignmentId());
      // });
    } else {}
  }

  void submit(
      {required String classId,
      required String assignmentId,
      required String subjectId,
      required List files}) async {
    List<String> urls = [];
    for (var file in files) {
      String url = await _storageRepository.uploadMaterial(
          file: file, classId: classId, assignmentId: assignmentId);
      urls.add(url);
    }
    final assignment = Assignment(
        id: assignmentId,
        title: state.title,
        description: state.description ?? '',
        materials: urls);
    print('assignment id');
    print(assignment.id);
    _assignmentRepository.createAssignment(
        assignment: assignment, classId: classId, subjectId: subjectId);
  }
}
