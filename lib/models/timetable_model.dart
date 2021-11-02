import 'package:equatable/equatable.dart';
import 'package:exam/screens/screens.dart';
import 'package:flutter/material.dart';

import 'models.dart';

class Timetable extends Equatable {
  final String title;
  final List subjects;

  const Timetable({required this.title, required this.subjects});

  static Timetable empty = const Timetable(title: '', subjects: []);

  Timetable copyWith({
    String? title,
    List? subjects,
  }) {
    if ((title == null || identical(title, this.title)) &&
        (subjects == null || identical(subjects, this.subjects))) {
      return this;
    }

    return Timetable(
      title: title ?? this.title,
      subjects: subjects ?? this.subjects,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'subjects': subjects.map((e) => e.toDocument()).toList()
    };
  }

  static Timetable fromMap(Map data) {
    return Timetable(
        title: data['title'],
        subjects:
            data['subjects'].map((e) => TimetableSubject.fromMap(e)).toList());
  }

  static List<DataColumn> getTableHeaders() {
    return ['Date', 'Subject', 'Start time', 'End time']
        .map((e) => DataColumn(
              label: Text(
                e,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ))
        .toList();
  }

  static List<DataRow> getTableRows(
      Timetable timetable, BuildContext context, Class classroom) {
    return timetable.subjects.map((e) {
      return DataRow(
          onSelectChanged: (bool? value) {
            Navigator.of(context).pushNamed(TimetableSubjectScreen.routeName,
                arguments: TimetableSubjectScreenArgs(classroom: classroom));
          },
          cells: <DataCell>[
            DataCell(Text(e.date.toString())),
            DataCell(Text(e.subject)),
            DataCell(Text(e.startTime.toString())),
            DataCell(Text(e.endTime.toString())),
          ]);
    }).toList();
  }

  @override
  List<Object?> get props => [];
}

class TimetableSubject extends Equatable {
  final String subject;
  final DateTime date;
  final DateTime startTime, endTime;
  final String? desc;
  final String? timeDesc;

  static TimetableSubject empty = TimetableSubject(
      subject: '',
      date: DateTime.now(),
      startTime: DateTime.now(),
      endTime: DateTime.now());

  TimetableSubject copyWith({
    String? subject,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? desc,
    String? timeDesc,
  }) {
    if ((subject == null || identical(subject, this.subject)) &&
        (date == null || identical(date, this.date)) &&
        (startTime == null || identical(startTime, this.startTime)) &&
        (endTime == null || identical(endTime, this.endTime)) &&
        (desc == null || identical(desc, this.desc)) &&
        (timeDesc == null || identical(timeDesc, this.timeDesc))) {
      return this;
    }

    return TimetableSubject(
      subject: subject ?? this.subject,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      desc: desc ?? this.desc,
      timeDesc: timeDesc ?? this.timeDesc,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'subject': subject,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'desc': desc ?? '',
      'timeDesc': timeDesc ?? ''
    };
  }

  static TimetableSubject? fromMap(Map? data) {
    if (data == null) return null;
    return TimetableSubject(
        subject: data['subject'],
        date: DateTime.parse(data['date'].toDate().toString()),
        startTime: DateTime.parse(data['startTime'].toDate().toString()),
        endTime: DateTime.parse(data['endTime'].toDate().toString()),
        desc: data['desc'],
        timeDesc: data['timeDesc']);
  }

  TimetableSubject(
      {required this.subject,
      required this.date,
      required this.startTime,
      required this.endTime,
      this.desc,
      this.timeDesc});

  @override
  List<Object?> get props =>
      [subject, date, startTime, endTime, desc, timeDesc];
}
