part of 'create_timetable_cubit.dart';

enum CreateTimetableStatus { initial, submitting, success, error }

class CreateTimetableState extends Equatable {
  // final Timetable timetable;
  final List<TimetableSubject> subjects;
  final String title, subjectTitle;
  final DateTime date;
  final TimeOfDay startTime, endTime;
  final String? desc, timeDesc;
  final CreateTimetableStatus status;
  final Failure failure;

  const CreateTimetableState(
      {required this.subjects,
      required this.title,
      required this.subjectTitle,
      required this.date,
      required this.startTime,
      required this.endTime,
      this.desc,
      this.timeDesc,
      required this.status,
      required this.failure});

  factory CreateTimetableState.initial() {
    return CreateTimetableState(
        subjects: [],
        title: '',
        date: DateTime.now(),
        endTime: TimeOfDay.now(),
        startTime: TimeOfDay.now(),
        subjectTitle: '',
        desc: '',
        timeDesc: '',
        status: CreateTimetableStatus.initial,
        failure: const Failure());
  }

  CreateTimetableState copyWith({
    List<TimetableSubject>? subjects,
    String? title,
    String? subjectTitle,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? desc,
    String? timeDesc,
    CreateTimetableStatus? status,
    Failure? failure,
  }) {
    if ((subjects == null || identical(subjects, this.subjects)) &&
        (title == null || identical(title, this.title)) &&
        (subjectTitle == null || identical(subjectTitle, this.subjectTitle)) &&
        (date == null || identical(date, this.date)) &&
        (startTime == null || identical(startTime, this.startTime)) &&
        (endTime == null || identical(endTime, this.endTime)) &&
        (desc == null || identical(desc, this.desc)) &&
        (timeDesc == null || identical(timeDesc, this.timeDesc)) &&
        (status == null || identical(status, this.status)) &&
        (failure == null || identical(failure, this.failure))) {
      return this;
    }

    return CreateTimetableState(
      subjects: subjects ?? this.subjects,
      title: title ?? this.title,
      subjectTitle: subjectTitle ?? this.subjectTitle,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      desc: desc ?? this.desc,
      timeDesc: timeDesc ?? this.timeDesc,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
        title,
        subjectTitle,
        date,
        startTime,
        endTime,
        desc,
        timeDesc,
        status,
        failure,
        subjects
      ];
}
