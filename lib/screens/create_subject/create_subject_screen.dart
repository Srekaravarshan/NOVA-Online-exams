import 'package:exam/repositories/repositories.dart';
import 'package:exam/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/create_subject_cubit.dart';

class CreateSubjectScreenArgs {
  final String classId;

  CreateSubjectScreenArgs({required this.classId});
}

class CreateSubjectScreen extends StatelessWidget {
  static const String routeName = '/createSubject';

  final String classId;

  CreateSubjectScreen({Key? key, required this.classId}) : super(key: key);

  static Route route({required CreateSubjectScreenArgs args}) {
    print("in route");
    print(args.classId);
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (_, __, ___) => BlocProvider<CreateSubjectCubit>(
              create: (context) => CreateSubjectCubit(
                  classesRepository: context.read<ClassesRepository>()),
              child: CreateSubjectScreen(classId: args.classId),
            ));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Subject'),
        ),
        body: BlocConsumer<CreateSubjectCubit, CreateSubjectState>(
          listener: (context, state) {
            if (state.status == CreateSubjectStatus.success) {
              _formKey.currentState?.reset();
              context.read<CreateSubjectCubit>().reset();

              Scaffold.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 1),
                  content: Text('Subject Created'),
                ),
              );
            } else if (state.status == CreateSubjectStatus.error) {
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
                  if (state.status == CreateSubjectStatus.submitting)
                    const LinearProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          textField(
                            hintText: 'Subject name',
                            onChanged: (value) => context
                                .read<CreateSubjectCubit>()
                                .nameChanged(value),
                            validator: (value) => value!.trim().isEmpty
                                ? 'Name cannot be empty.'
                                : null,
                          ),
                          addVerticalSpace(30),
                          SizedBox(
                            height: 58,
                            child: ElevatedButton(
                              onPressed: () => _submitForm(
                                context,
                                state.status == CreateSubjectStatus.submitting,
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
      context.read<CreateSubjectCubit>().submit(classId: classId);
      Navigator.pop(context);
    }
  }
}
