import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Subject extends Equatable {
  final String id;
  final String name;
  final List materials;

  const Subject(
      {required this.id, required this.name, required this.materials});

  static Subject empty = const Subject(id: '', name: '', materials: []);

  Subject copyWith({
    String? id,
    String? name,
    List? materials,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (name == null || identical(name, this.name)) &&
        (materials == null || identical(materials, this.materials))) {
      return this;
    }

    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      materials: materials ?? this.materials,
    );
  }

  Map<String, dynamic> toDocument() {
    return {'id': id, 'name': name, 'materials': materials};
  }

  static Subject? fromDocument(DocumentSnapshot<Map>? doc) {
    if (doc == null) return null;
    final data = doc.data();
    return Subject(
        id: doc.id,
        name: data != null ? data['name'] : '',
        materials: data != null ? data['materials'] : []);
  }

  @override
  List<Object?> get props => [id, name, materials];
}
