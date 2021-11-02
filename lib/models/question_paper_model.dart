import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:exam/models/models.dart';

class QuestionPaper extends Equatable {
  final String set;
  final String mode;
  final String status;
  final List sections;
  final String id;

  const QuestionPaper(
      {required this.id,
      required this.set,
      required this.mode,
      required this.sections,
      required this.status});

  static QuestionPaper empty = const QuestionPaper(
      id: '', set: '', sections: [], mode: 'mcq', status: 'initial');

  QuestionPaper copyWith({
    String? set,
    String? mode,
    String? status,
    List? sections,
    String? id,
  }) {
    if ((set == null || identical(set, this.set)) &&
        (mode == null || identical(mode, this.mode)) &&
        (status == null || identical(status, this.status)) &&
        (sections == null || identical(sections, this.sections)) &&
        (id == null || identical(id, this.id))) {
      return this;
    }

    return QuestionPaper(
      set: set ?? this.set,
      mode: mode ?? this.mode,
      status: status ?? this.status,
      sections: sections ?? this.sections,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'set': set,
      'mode': mode,
      'status': status,
      'sections': sections.map((section) => section.toDocument()).toList()
    };
  }

  factory QuestionPaper.fromMap(Map? data) {
    return QuestionPaper(
        set: data != null ? data['set'] : '',
        mode: data != null ? data['mode'] : '',
        sections: data != null
            ? data['sections'].map((section) => Section.fromMap(section))
            : [],
        status: data != null ? data['status'] : 'initial',
        id: data != null ? data['id'] : '');
  }

  static QuestionPaper? fromDocument(DocumentSnapshot<Map>? doc) {
    if (doc == null) return null;
    final data = doc.data();
    return QuestionPaper(
        set: data != null ? data['set'] : '',
        mode: data != null ? data['mode'] : '',
        sections: data != null
            ? data['sections'].map((section) => Section.fromMap(section))
            : [],
        status: data != null ? data['status'] : 'initial',
        id: data != null ? data['id'] : '');
  }

  @override
  List<Object?> get props => [set, mode, sections, status];
}
