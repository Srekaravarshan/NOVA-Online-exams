import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exam/models/models.dart';
import 'package:exam/repositories/repositories.dart';
import 'package:flutter/material.dart';

part 'create_timetable_state.dart';

class CreateTimetableCubit extends Cubit<CreateTimetableState> {
  final ClassesRepository _classesRepository;

  CreateTimetableCubit({required ClassesRepository classesRepository})
      : _classesRepository = classesRepository,
        super(CreateTimetableState.initial());

  void titleChanged(String value) {
    emit(state.copyWith(title: value, status: CreateTimetableStatus.initial));
  }

  void dateChanged(DateTime value) {
    emit(state.copyWith(date: value, status: CreateTimetableStatus.initial));
  }

  void subjectTitleChanged(String value) {
    emit(state.copyWith(
        subjectTitle: value, status: CreateTimetableStatus.initial));
  }

  void startTimeChanged(TimeOfDay value) {
    emit(state.copyWith(
        startTime: value, status: CreateTimetableStatus.initial));
  }

  void endTimeChanged(TimeOfDay value) {
    emit(state.copyWith(endTime: value, status: CreateTimetableStatus.initial));
  }

  void descChanged(String value) {
    emit(state.copyWith(desc: value, status: CreateTimetableStatus.initial));
  }

  void timeDescChanged(String value) {
    emit(
        state.copyWith(timeDesc: value, status: CreateTimetableStatus.initial));
  }

  void reset() {
    emit(CreateTimetableState.initial());
  }

  void resetSubject() {
    emit(state.copyWith(subjectTitle: '', timeDesc: '', desc: ''));
  }

  void addSubject() {
    final now = DateTime.now();
    state.subjects.add(TimetableSubject(
        subject: state.subjectTitle,
        date: state.date,
        startTime: DateTime(now.year, now.month, now.day, state.startTime.hour,
            state.startTime.minute),
        endTime: DateTime(now.year, now.month, now.day, state.endTime.hour,
            state.endTime.minute),
        desc: state.desc,
        timeDesc: state.timeDesc));
    emit(state);
    resetSubject();
  }

  void pickDate({required BuildContext context}) async {
    DateTime? d = await showDatePicker(
      context: context,
      initialDate: state.date,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (d != null) {
      emit(state.copyWith(date: d, status: CreateTimetableStatus.initial));
    }
  }

  void pickTime({required BuildContext context, required String time}) async {
    TimeOfDay? t = await showTimePicker(
      context: context,
      initialTime: time == 'startTime' ? state.startTime : state.endTime,
    );
    if (t != null) {
      time == 'startTime'
          ? emit(state.copyWith(
              startTime: t, status: CreateTimetableStatus.initial))
          : emit(state.copyWith(
              endTime: t, status: CreateTimetableStatus.initial));
    }
  }

  Future<void> submit({required String classId}) async {
    emit(state.copyWith(status: CreateTimetableStatus.submitting));
    try {
      final timetable = Timetable(title: state.title, subjects: state.subjects);
      await _classesRepository.updateTimetable(
          timetable: timetable, classId: classId);
      emit(state.copyWith(status: CreateTimetableStatus.success));
    } catch (err) {
      emit(state.copyWith(
          status: CreateTimetableStatus.error,
          failure:
              const Failure(message: 'We are unable to create timetable')));
    }
  }
}
