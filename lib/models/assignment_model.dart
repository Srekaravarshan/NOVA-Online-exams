import 'package:cloud_firestore/cloud_firestore.dart';

class Assignments {
  final Map assignments;

  Assignments({required this.assignments});

  static Assignments empty = Assignments(assignments: {});

  Map<String, dynamic> toDocument() {
    return {'assignments': assignments};
  }

  static Assignments fromDocument(DocumentSnapshot<Map>? doc) {
    if (doc == null) return empty;
    final data = doc.data();
    return Assignments(assignments: data != null ? data['assignments'] : {});
  }
}

class Assignment {
  final String id, title, description;
  final List materials;

  Assignment(
      {required this.id,
      required this.title,
      required this.description,
      required this.materials});

  static Assignment empty =
      Assignment(title: '', description: '', materials: [], id: '');

  Assignment copyWith({
    String? id,
    String? title,
    String? description,
    List? materials,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (title == null || identical(title, this.title)) &&
        (description == null || identical(description, this.description)) &&
        (materials == null || identical(materials, this.materials))) {
      return this;
    }

    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      materials: materials ?? this.materials,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'materials': materials
    };
  }

  static Assignment fromDocument(DocumentSnapshot<Map>? doc) {
    if (doc == null) return empty;
    final data = doc.data();
    return Assignment(
        materials: data != null ? data['materials'] : [],
        description: data != null ? data['description'] : '',
        title: data != null ? data['title'] : '',
        id: data != null ? data['id'] : '');
  }
}
