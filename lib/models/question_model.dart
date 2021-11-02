import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final Map question;
  final String questionType;
  final int questionNo;

  Question(
      {required this.question,
      required this.questionType,
      required this.questionNo});

  static Question empty =
      Question(question: {}, questionType: '', questionNo: 0);

  Question copyWith({
    Map? question,
    String? questionType,
    int? questionNo,
  }) {
    if ((question == null || identical(question, this.question)) &&
        (questionType == null || identical(questionType, this.questionType)) &&
        (questionNo == null || identical(questionNo, this.questionNo))) {
      return this;
    }

    return Question(
      question: question ?? this.question,
      questionType: questionType ?? this.questionType,
      questionNo: questionNo ?? this.questionNo,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'question': question,
      'questionType': questionType,
      'questionNo': questionNo
    };
  }

  factory Question.fromMap(Map? data) {
    return Question(
        question: data != null ? data['question'] : {},
        questionType: data != null ? data['questionType'] : '',
        questionNo: data != null ? data['questionNo'] : []);
  }

  static Question? fromDocument(DocumentSnapshot<Map>? doc) {
    if (doc == null) return null;
    final data = doc.data();
    return Question(
        question: data != null ? data['question'] : {},
        questionType: data != null ? data['questionType'] : '',
        questionNo: data != null ? data['questionNo'] : []);
  }

  @override
  List<Object?> get props => [question, questionType, questionNo];
}

class Section extends Equatable {
  final int order;
  final List questions;
  final String title;

  const Section(
      {required this.order, required this.questions, required this.title});

  static Section empty = Section(order: 0, questions: const [], title: '');

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
