import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam/config/paths.dart';
import 'package:exam/models/failure_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'base_auth_repository.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository({
    FirebaseFirestore? firebaseFirestore,
    auth.FirebaseAuth? firebaseAuth,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Stream<auth.User?> get user => _firebaseAuth.userChanges();

  @override
  Future<auth.User?> signUpWithGoogle() async {
    try {
      print("signin");
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print("googleuser");
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      print("google auth");
      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      print(credential);
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      print(_firebaseAuth.currentUser);
      print("user");
      print(userCredential.user);
      _firebaseFirestore
          .collection(Paths.users)
          .doc(userCredential.user?.uid)
          .set({
        'username': userCredential.user?.displayName,
        'email': userCredential.user?.email,
        'teachingClasses': [],
        'classrooms': []
      });
      return userCredential.user;
    } on auth.FirebaseAuthException catch (err) {
      throw Failure(code: err.code, message: err.message);
    } on PlatformException catch (err) {
      throw Failure(code: err.code, message: err.message);
    }
  }

  @override
  Future<auth.User?> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      _firebaseFirestore.collection(Paths.users).doc(user?.uid).set({
        'username': username,
        'email': email,
      });
      return user;
    } on auth.FirebaseAuthException catch (err) {
      throw Failure(code: err.code, message: err.message);
    } on PlatformException catch (err) {
      throw Failure(code: err.code, message: err.message);
    }
  }

  @override
  Future<auth.User?> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on auth.FirebaseAuthException catch (err) {
      throw Failure(code: err.code, message: err.message);
    } on PlatformException catch (err) {
      throw Failure(code: err.code, message: err.message);
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}
