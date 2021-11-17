import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum QuestionType {
  shortAnswer,
  paragraph,
  choice,
  checkBox,
  dropdown,
  addFile,
  titleAndDescription,
  image,
  video
}

class Question extends Equatable {
  final String title;
  final String description;
  final String answer;
  final bool isQuestion;
  final List options;
  bool hasOtherOption;
  String? otherOption;
  final QuestionType type;
  final int questionNo;
  final File? file;

  Question(
      {required this.title,
      required this.description,
      required this.answer,
      required this.isQuestion,
      required this.options,
      required this.hasOtherOption,
      this.otherOption,
      required this.type,
      required this.questionNo,
      this.file});

  static Question empty = Question(
      type: QuestionType.choice,
      questionNo: 0,
      description: '',
      hasOtherOption: false,
      options: const [],
      title: '',
      answer: '',
      isQuestion: true);

  Question copyWith({
    String? title,
    String? description,
    String? answer,
    bool? isQuestion,
    List? options,
    bool? hasOtherOption,
    String? otherOption,
    QuestionType? type,
    int? questionNo,
    File? file,
  }) {
    return Question(
      title: title ?? this.title,
      description: description ?? this.description,
      answer: answer ?? this.answer,
      isQuestion: isQuestion ?? this.isQuestion,
      options: options ?? this.options,
      hasOtherOption: hasOtherOption ?? this.hasOtherOption,
      otherOption: otherOption ?? this.otherOption,
      type: type ?? this.type,
      questionNo: questionNo ?? this.questionNo,
      file: file ?? this.file,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'description': description,
      'answer': answer,
      'isQuestion': isQuestion,
      'options': options,
      'hasOtherOption': hasOtherOption,
      'otherOption': otherOption,
      'file': file,
      'type': type.toString(),
      'questionNo': questionNo
    };
  }

  factory Question.fromMap(Map? data) {
    return Question(
        type: data != null
            ? QuestionType.values
                .firstWhere((e) => e.toString() == data['type'])
            : QuestionType.choice,
        questionNo: data != null ? data['questionNo'] : [],
        description: data != null ? data['description'] : '',
        title: data != null ? data['title'] : '',
        isQuestion: data != null ? data['isQuestion'] : true,
        options: data != null ? data['options'] : [],
        answer: data != null ? data['answer'] : '',
        hasOtherOption: data != null ? data['hasOtherOption'] : false,
        file: data != null ? data['file'] : null,
        otherOption: data != null ? data['otherOption'] : '');
  }

  static Question? fromDocument(DocumentSnapshot<Map>? doc) {
    if (doc == null) return null;
    final data = doc.data();
    return Question(
        type: data != null
            ? QuestionType.values
                .firstWhere((e) => e.toString() == data['type'])
            : QuestionType.choice,
        questionNo: data != null ? data['questionNo'] : [],
        description: data != null ? data['description'] : '',
        title: data != null ? data['title'] : '',
        isQuestion: data != null ? data['isQuestion'] : true,
        options: data != null ? data['options'] : [],
        answer: data != null ? data['answer'] : '',
        hasOtherOption: data != null ? data['hasOtherOption'] : false,
        file: data != null ? data['file'] : null,
        otherOption: data != null ? data['otherOption'] : '');
  }

  @override
  List<Object?> get props => [
        questionNo,
        description,
        title,
        isQuestion,
        options,
        answer,
        hasOtherOption,
        file,
        otherOption,
        type
      ];
}

class Section extends Equatable {
  final int order;
  List questions;
  final String title;

  Section({required this.order, required this.questions, required this.title});

  static Section empty =
      Section(order: 0, questions: const [], title: 'Untitled');

  Section copyWith({
    int? order,
    List? questions,
    String? title,
  }) {
    if ((order == null || identical(order, this.order)) &&
        (questions == null || identical(questions, this.questions)) &&
        (title == null || identical(title, this.title))) {
      return this;
    }

    return Section(
      order: order ?? this.order,
      questions: questions ?? this.questions,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'order': order,
      'questions': questions.map((question) => question.toDocument()).toList(),
      'title': title
    };
  }

  factory Section.fromMap(Map? data) {
    return Section(
        title: data != null ? data['title'] : '',
        order: data != null ? data['order'] : 0,
        questions: data != null
            ? data['questions']
                .map((question) => Question.fromMap(question))
                .toList()
            : []);
  }

  static Section? fromDocument(DocumentSnapshot<Map>? doc) {
    if (doc == null) return null;
    final data = doc.data();
    return Section(
        title: data != null ? data['title'] : '',
        order: data != null ? data['order'] : 0,
        questions: data != null
            ? data['questions']
                .map((question) => Question.fromMap(question))
                .toList()
            : []);
  }

  @override
  List<Object?> get props => [];
}
