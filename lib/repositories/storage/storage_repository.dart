import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam/config/paths.dart';
import 'package:exam/models/models.dart';
import 'package:exam/repositories/storage/base_storage_repostiory.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageRepository extends BaseStorageRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  StorageRepository(
      {FirebaseStorage? firebaseStorage, FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  @override
  Future<String> uploadMaterial(
      {required File file,
      required String classId,
      required String assignmentId}) async {
    String? fileId = const Uuid().v4();
    final downloadUrl = await uploadFile(
      file: file,
      ref: 'materials/$assignmentId/$fileId',
    );

    return downloadUrl;
  }

  @override
  Future<String> uploadFile({required File file, required String ref}) async {
    final String downloadUrl = await _firebaseStorage
        .ref(ref)
        .putFile(file)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
    return downloadUrl;
  }

  @override
  Future getFile({required String classId}) async {
    Assignment assignment = Assignment.fromDocument(await _firebaseFirestore
        .collection(Paths.materials)
        .doc(classId)
        .get());

    List files = [];
  }

  Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  @override
  Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }
}
