import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam/config/paths.dart';
import 'package:exam/models/models.dart';
import 'package:exam/repositories/user/base_user_repository.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<User?> getUserWithId({required String userId}) async {
    print("getuserwithid " + userId);
    final DocumentSnapshot<Map> doc =
        await _firebaseFirestore.collection(Paths.users).doc(userId).get();
    print(doc.exists);
    return doc.exists ? User.fromDocument(doc) : User.empty;
  }

  @override
  Future<void> updateUser({required User user}) async {
    await _firebaseFirestore
        .collection(Paths.users)
        .doc(user.id)
        .update(user.toDocument());
  }
}
