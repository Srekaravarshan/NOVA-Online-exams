import 'package:exam/repositories/repositories.dart';
import 'package:exam/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'cubit/create_assignment_cubit.dart';

class CreateAssignmentScreenArgs {
  final String classId, subjectId;

  CreateAssignmentScreenArgs({required this.classId, required this.subjectId});
}

class CreateAssignmentScreen extends StatelessWidget {
  static const String routeName = '/createAssignment';
  String assignmentId = const Uuid().v4();

  final String classId, subjectId;

  CreateAssignmentScreen(
      {Key? key, required this.classId, required this.subjectId})
      : super(key: key);

  static Route route({required CreateAssignmentScreenArgs args}) {
    print("in route");
    print(args.classId);
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (_, __, ___) => BlocProvider<CreateAssignmentCubit>(
              create: (context) => CreateAssignmentCubit(
                  assignmentRepository: context.read<AssignmentRepository>(),
                  storageRepository: context.read<StorageRepository>()),
              child: CreateAssignmentScreen(
                classId: args.classId,
                subjectId: args.subjectId,
              ),
            ));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<CreateAssignmentCubit, CreateAssignmentState>(
        listener: (context, state) {
          if (state.status == CreateAssignmentStatus.success) {
            _formKey.currentState?.reset();
            context.read<CreateAssignmentCubit>().reset();

            Scaffold.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
                content: Text('Assignment Created'),
              ),
            );
          } else if (state.status == CreateAssignmentStatus.error) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(content: state.failure.message),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Create Assignment'),
              actions: [
                IconButton(
                    onPressed: () {
                      context
                          .read<CreateAssignmentCubit>()
                          .pickFiles(classId: classId);
                    },
                    icon: const Icon(Icons.link))
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  if (state.status == CreateAssignmentStatus.submitting)
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
                                .read<CreateAssignmentCubit>()
                                .titleChanged(value),
                            validator: (value) => value!.trim().isEmpty
                                ? 'Name cannot be empty.'
                                : null,
                          ),
                          addVerticalSpace(15),
                          textField(
                            hintText: 'Description',
                            onChanged: (value) => context
                                .read<CreateAssignmentCubit>()
                                .descriptionChanged(value),
                          ),
                          addVerticalSpace(30),
                          SizedBox(
                            height: 58,
                            child: ElevatedButton(
                              onPressed: () => _submitForm(
                                  context,
                                  state.status ==
                                      CreateAssignmentStatus.submitting,
                                  state),
                              child: const Text('Submit'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitForm(
      BuildContext context, bool isSubmitting, CreateAssignmentState state) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<CreateAssignmentCubit>().submit(
          classId: classId,
          assignmentId: assignmentId,
          subjectId: subjectId,
          files: state.fileUrls);
      Navigator.pop(context);
    }
  }
}
