import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:exam/models/models.dart';

class Class extends Equatable {
  final String id, name;
  final String? section, room;
  final List teachers, students;
  final Timetable timetable;
  final List questionPapers;

  const Class(
      {required this.id,
      required this.timetable,
      required this.name,
      this.section,
      this.room,
      required this.teachers,
      required this.students,
      required this.questionPapers});

  static Class empty = Class(
      id: '',
      name: '',
      teachers: [],
      students: [],
      room: '',
      section: '',
      timetable: Timetable.empty,
      questionPapers: const []);

  Class copyWith({
    String? id,
    String? name,
    String? section,
    String? room,
    List? teachers,
    List? students,
    Timetable? timetable,
    List? questionPapers,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (name == null || identical(name, this.name)) &&
        (section == null || identical(section, this.section)) &&
        (room == null || identical(room, this.room)) &&
        (teachers == null || identical(teachers, this.teachers)) &&
        (students == null || identical(students, this.students)) &&
        (timetable == null || identical(timetable, this.timetable)) &&
        (questionPapers == null ||
            identical(questionPapers, this.questionPapers))) {
      return this;
    }

    return Class(
      id: id ?? this.id,
      name: name ?? this.name,
      section: section ?? this.section,
      room: room ?? this.room,
      teachers: teachers ?? this.teachers,
      students: students ?? this.students,
      timetable: timetable ?? this.timetable,
      questionPapers: questionPapers ?? this.questionPapers,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'section': section,
      'room': room,
      'teachers': teachers,
      'students': students,
      'timetable': timetable.toDocument(),
      'questionPapers': questionPapers
          .map((questionPaper) => questionPaper.toDocument())
          .toList()
    };
  }

  factory Class.fromMap(Map? data, String id) {
    return Class(
        id: id,
        name: data != null ? data['name'] : '',
        teachers: data != null ? data['section'] : [],
        students: data != null ? data['room'] : [],
        section: data != null ? data['subject'] : '',
        room: data != null ? data['teachers'] : '',
        timetable: data != null
            ? Timetable.fromMap(data['timetable'])
            : Timetable.empty,
        questionPapers: data != null
            ? data['questionPapers']
                .map((questionPaper) => QuestionPaper.fromMap(questionPaper))
                .toList()
            : []);
  }

  static Class? fromDocument(DocumentSnapshot<Map>? doc) {
    if (doc == null) return null;
    final data = doc.data();
    return Class(
        id: doc.id,
        name: data != null ? data['name'] : '',
        teachers: data != null ? data['teachers'] : [],
        students: data != null ? data['students'] : [],
        section: data != null ? data['subject'] : '',
        room: data != null ? data['room'] : '',
        timetable: data != null
            ? Timetable.fromMap(data['timetable'])
            : Timetable.empty,
        questionPapers: data != null
            ? data['questionPapers']
                .map((questionPaper) => QuestionPaper.fromMap(questionPaper))
                .toList()
            : []);
  }

  @override
  List<Object?> get props =>
      [id, name, section, room, teachers, students, timetable, questionPapers];
}
