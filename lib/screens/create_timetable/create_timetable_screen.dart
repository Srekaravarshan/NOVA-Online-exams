import 'package:exam/repositories/repositories.dart';
import 'package:exam/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                          TextFormField(
                            decoration:
                                const InputDecoration(hintText: 'Title'),
                            onChanged: (value) => context
                                .read<CreateTimetableCubit>()
                                .titleChanged(value),
                            validator: (value) => value!.trim().isEmpty
                                ? 'Name cannot be empty.'
                                : null,
                          ),
                          SizedBox(height: 20),
                          Container(
                            // width: MediaQuery.of(context).size.width*0.9,
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: 'Subject'),
                                  onChanged: (value) => context
                                      .read<CreateTimetableCubit>()
                                      .subjectTitleChanged(value),
                                  validator: (value) => value!.trim().isEmpty
                                      ? 'Name cannot be empty.'
                                      : null,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: 'Description'),
                                  onChanged: (value) => context
                                      .read<CreateTimetableCubit>()
                                      .subjectTitleChanged(value),
                                ),
                                ListTile(
                                  title: Text("Date: " + state.date.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  onTap: () => context
                                      .read<CreateTimetableCubit>()
                                      .pickDate(context: context),
                                ),
                                ListTile(
                                  title: Text(
                                      "Start time: " +
                                          state.startTime.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  onTap: () => context
                                      .read<CreateTimetableCubit>()
                                      .pickTime(
                                          context: context, time: 'startTime'),
                                ),
                                ListTile(
                                  title: Text(
                                      "End time: " + state.endTime.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  onTap: () => context
                                      .read<CreateTimetableCubit>()
                                      .pickTime(
                                          context: context, time: 'endTime'),
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: 'TimeDescription'),
                                  onChanged: (value) => context
                                      .read<CreateTimetableCubit>()
                                      .subjectTitleChanged(value),
                                ),
                                Row(
                                  children: [
                                    TextButton(
                                        onPressed: () {},
                                        child: const Text('Cancel')),
                                    TextButton(
                                        onPressed: () => context
                                            .read<CreateTimetableCubit>()
                                            .addSubject(),
                                        child: const Text('Add')),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 28.0),
                          RaisedButton(
                            elevation: 1.0,
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () => _submitForm(
                              context,
                              state.status == CreateTimetableStatus.submitting,
                            ),
                            child: const Text('Timetable'),
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
}
