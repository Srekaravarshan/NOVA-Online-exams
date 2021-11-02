import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final List teachingClasses, classrooms;

  const User(
      {required this.id,
      required this.username,
      required this.email,
      required this.teachingClasses,
      required this.classrooms});

  static User empty = const User(
      id: '', username: '', email: '', teachingClasses: [], classrooms: []);

  User copyWith({
    String? id,
    String? username,
    String? email,
    List? teachingClasses,
    List? classrooms,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (username == null || identical(username, this.username)) &&
        (email == null || identical(email, this.email)) &&
        (teachingClasses == null ||
            identical(teachingClasses, this.teachingClasses)) &&
        (classrooms == null || identical(classrooms, this.classrooms))) {
      return this;
    }

    return User(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        teachingClasses: teachingClasses ?? this.teachingClasses,
        classrooms: classrooms ?? this.classrooms);
  }

  Map<String, dynamic> toDocument() {
    return {
      'username': username,
      'email': email,
      'teachingClasses': teachingClasses,
      'classrooms': classrooms
    };
  }

  static User? fromDocument(DocumentSnapshot<Map>? doc) {
    if (doc == null) return null;
    final data = doc.data();
    print(data);
    print(data != null ? data['username'] : '');
    print(data != null ? data['email'] : '');
    return User(
        id: doc.id,
        username: data != null ? data['username'] : '',
        email: data != null ? data['email'] : '',
        teachingClasses: data != null ? data['teachingClasses'] : [],
        classrooms: data != null ? data['classrooms'] : []);
  }

  @override
  List<Object?> get props => [id, username, email, teachingClasses, classrooms];
}
