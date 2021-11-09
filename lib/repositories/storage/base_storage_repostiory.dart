import 'dart:io';

import 'package:exam/models/models.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class BaseStorageRepository {
  Future<String> uploadMaterial(
      {required File file,
      required String classId,
      required String assignmentId});
  Future<String> uploadFile({required File file, required String ref});
  Future getFile({required String classId});
  Future<List<String>> _getDownloadLinks(List<Reference> refs);
  Future<List<FirebaseFile>> listAll(String path);
}
