import 'package:exam/blocs/blocs.dart';
import 'package:exam/repositories/repositories.dart';
import 'package:exam/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cubit/create_class_cubit.dart';

class CreateClassScreen extends StatelessWidget {
  static const String routeName = '/createClass';

  CreateClassScreen({Key? key}) : super(key: key);

  static Route route() {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (_, __, ___) => BlocProvider<CreateClassCubit>(
              create: (context) => CreateClassCubit(
                  classesRepository: context.read<ClassesRepository>(),
                  userRepository: context.read<UserRepository>(),
                  authBloc: context.read<AuthBloc>()),
              child: CreateClassScreen(),
            ));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Class'),
        ),
        body: BlocConsumer<CreateClassCubit, CreateClassState>(
          listener: (context, state) {
            if (state.status == CreateClassStatus.success) {
              _formKey.currentState?.reset();
              context.read<CreateClassCubit>().reset();
            } else if (state.status == CreateClassStatus.error) {
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
                  if (state.status == CreateClassStatus.submitting)
                    const LinearProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          textField(
                              hintText: 'Class name',
                              onChanged: (value) => context
                                  .read<CreateClassCubit>()
                                  .nameChanged(value),
                              validator: (value) => value!.trim().isEmpty
                                  ? 'Name cannot be empty.'
                                  : null),
                          addVerticalSpace(15),
                          textField(
                              hintText: 'Section',
                              onChanged: (value) => context
                                  .read<CreateClassCubit>()
                                  .sectionChanged(value)),
                          addVerticalSpace(15),
                          textField(
                            hintText: 'Room',
                            onChanged: (value) => context
                                .read<CreateClassCubit>()
                                .roomChanged(value),
                          ),
                          addVerticalSpace(30),
                          SizedBox(
                            height: 58,
                            child: ElevatedButton(
                              onPressed: () => _submitForm(
                                context,
                                state.status == CreateClassStatus.submitting,
                              ),
                              child: Text(
                                'Submit',
                                style: GoogleFonts.lato(fontSize: 16),
                              ),
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
      context.read<CreateClassCubit>().submit();
      Navigator.pop(context);
    }
  }
}
