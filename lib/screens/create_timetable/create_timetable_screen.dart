import 'package:exam/constants/constants.dart';
import 'package:exam/repositories/repositories.dart';
import 'package:exam/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cubit/create_timetable_cubit.dart';

class CreateTimetableScreenArgs {
  final String classId;

  CreateTimetableScreenArgs({required this.classId});
}

class CreateTimetableScreen extends StatelessWidget {
  static const String routeName = '/createTimetable';

  final String classId;

  CreateTimetableScreen({Key? key, required this.classId}) : super(key: key);

  static Route route({required CreateTimetableScreenArgs args}) {
    print("in route");
    print(args.classId);
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (_, __, ___) => BlocProvider<CreateTimetableCubit>(
              create: (context) => CreateTimetableCubit(
                  classesRepository: context.read<ClassesRepository>()),
              child: CreateTimetableScreen(classId: args.classId),
            ));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Timetable'),
        ),
        body: BlocConsumer<CreateTimetableCubit, CreateTimetableState>(
          listener: (context, state) {
            if (state.status == CreateTimetableStatus.success) {
              _formKey.currentState?.reset();
              context.read<CreateTimetableCubit>().reset();

              Scaffold.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 1),
                  content: Text('Timetable Created'),
                ),
              );
            } else if (state.status == CreateTimetableStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (state.status == CreateTimetableStatus.submitting)
                    const LinearProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          textField(
                              hintText: 'Title',
                              onChanged: (value) => context
                                  .read<CreateTimetableCubit>()
                                  .titleChanged(value),
                              validator: (value) => value!.trim().isEmpty
                                  ? 'Name cannot be empty.'
                                  : null,
                              autofocus: true),
                          addVerticalSpace(20),
                          subjectsWidget(state: state),
                          addVerticalSpace(20),
                          _newSubjectWidget(context: context, state: state),
                          addVerticalSpace(30),
                          SizedBox(
                            height: 58,
                            child: ElevatedButton(
                              onPressed: () => _submitForm(
                                context,
                                state.status ==
                                    CreateTimetableStatus.submitting,
                              ),
                              child: const Text('Submit'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<CreateTimetableCubit>().submit(classId: classId);
      Navigator.pop(context);
    }
  }

  Widget subjectsWidget({required CreateTimetableState state}) {
    return ListView.separated(
      itemCount: state.subjects.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: const BorderRadius.all(Radius.circular(4))),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: Text(state.subjects[index].subject,
                  style: GoogleFonts.lato(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        dateTimeButton(
                          title: "Date",
                          dateTime: dateFormat.format(state.date),
                        ),
                        addHorizontalSpace(10),
                        dateTimeButton(
                          title: "Start time",
                          dateTime: timeFormat
                              .format(state.subjects[index].startTime),
                        ),
                        addHorizontalSpace(10),
                        dateTimeButton(
                          title: 'End time',
                          dateTime:
                              timeFormat.format(state.subjects[index].endTime),
                        ),
                      ],
                    ),
                  ),
                  state.subjects[index].desc!.isNotEmpty
                      ? addVerticalSpace(8)
                      : Container(),
                  state.subjects[index].desc!.isNotEmpty
                      ? Text(state.subjects[index].desc ?? '')
                      : Container(),
                  state.subjects[index].timeDesc!.isNotEmpty
                      ? addVerticalSpace(8)
                      : Container(),
                  state.subjects[index].timeDesc!.isNotEmpty
                      ? Text(state.subjects[index].timeDesc ?? '')
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
      separatorBuilder: (BuildContext context, int index) =>
          addVerticalSpace(8),
    );
  }

  Widget dateTimeButton(
      {required String title,
      required String dateTime,
      Function()? onPressed}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.black54)),
        onPressed == null
            ? Text(dateTime,
                style: const TextStyle(color: Colors.black, fontSize: 14))
            : OutlinedButton(
                onPressed: onPressed,
                child: Text(
                  dateTime,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              )
      ],
    );
  }

  Widget _newSubjectWidget(
      {required BuildContext context, required CreateTimetableState state}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: Colors.black26),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 5, offset: Offset(0, 2))
          ]),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Text('Add subject',
                style: GoogleFonts.lato(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.black)),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textField(
                  hintText: 'Subject',
                  onChanged: (value) => context
                      .read<CreateTimetableCubit>()
                      .subjectTitleChanged(value),
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Name cannot be empty.' : null,
                ),
                addVerticalSpace(8),
                textField(
                  hintText: 'Description',
                  onChanged: (value) =>
                      context.read<CreateTimetableCubit>().descChanged(value),
                ),
                addVerticalSpace(12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      dateTimeButton(
                        title: "Date",
                        dateTime: dateFormat.format(state.date),
                        onPressed: () => context
                            .read<CreateTimetableCubit>()
                            .pickDate(context: context),
                      ),
                      addHorizontalSpace(10),
                      dateTimeButton(
                        title: "Start time",
                        dateTime: state.startTime.format(context),
                        onPressed: () => context
                            .read<CreateTimetableCubit>()
                            .pickTime(context: context, time: 'startTime'),
                      ),
                      addHorizontalSpace(10),
                      dateTimeButton(
                        title: 'End time',
                        dateTime: state.endTime.format(context),
                        onPressed: () => context
                            .read<CreateTimetableCubit>()
                            .pickTime(context: context, time: 'endTime'),
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(12),
                textField(
                  hintText: 'TimeDescription',
                  onChanged: (value) => context
                      .read<CreateTimetableCubit>()
                      .timeDescChanged(value),
                ),
                addVerticalSpace(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () =>
                            context.read<CreateTimetableCubit>().addSubject(),
                        child: const Text('Add')),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
