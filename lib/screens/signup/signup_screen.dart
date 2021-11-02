import 'package:exam/repositories/repositories.dart';
import 'package:exam/screens/signup/cubit/signup_cubit.dart';
import 'package:exam/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = '/signup';

  static Route route() {
    return MaterialPageRoute(
        builder: (context) => BlocProvider<SignupCubit>(
              create: (context) =>
                  SignupCubit(authRepository: context.read<AuthRepository>()),
              child: SignupScreen(),
            ));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.status == SignupStatus.error) {
              showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(
                        content: state.failure.message,
                      ));
            }
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Instagram',
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12.0),
                            TextFormField(
                              decoration:
                                  const InputDecoration(hintText: 'Username'),
                              onChanged: (value) => context
                                  .read<SignupCubit>()
                                  .usernameChanged(value),
                              validator: (value) => !(value!.trim().length > 3)
                                  ? 'Please enter greater than 3 letters.'
                                  : null,
                            ),
                            const SizedBox(height: 16.0),
                            // TextFormField(
                            //   decoration:
                            //       const InputDecoration(hintText: 'Class name'),
                            //   onChanged: (value) => context
                            //       .read<SignupCubit>()
                            //       .classNameChanged(value),
                            // ),
                            // const SizedBox(height: 16.0),
                            // TextFormField(
                            //   decoration:
                            //       const InputDecoration(hintText: 'Section'),
                            //   onChanged: (value) => context
                            //       .read<SignupCubit>()
                            //       .sectionChanged(value),
                            // ),
                            // const SizedBox(height: 16.0),
                            // TextFormField(
                            //   decoration:
                            //       const InputDecoration(hintText: 'Room'),
                            //   onChanged: (value) => context
                            //       .read<SignupCubit>()
                            //       .roomChanged(value),
                            // ),
                            // const SizedBox(height: 16.0),
                            // TextFormField(
                            //   decoration:
                            //       const InputDecoration(hintText: 'Subject'),
                            //   onChanged: (value) => context
                            //       .read<SignupCubit>()
                            //       .subjectChanged(value),
                            // ),
                            // const SizedBox(height: 16.0),
                            TextFormField(
                              decoration:
                                  const InputDecoration(hintText: 'Email'),
                              onChanged: (value) => context
                                  .read<SignupCubit>()
                                  .emailChanged(value),
                              validator: (value) => !value!.contains('@')
                                  ? 'Please enter a valid email.'
                                  : null,
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              obscureText: true,
                              decoration:
                                  const InputDecoration(hintText: 'Password'),
                              onChanged: (value) => context
                                  .read<SignupCubit>()
                                  .passwordChanged(value),
                              validator: (value) => value!.length < 6
                                  ? 'Must be at least 6 characters.'
                                  : null,
                            ),
                            const SizedBox(height: 28.0),
                            ElevatedButton(
                              onPressed: () => _submitForm(context,
                                  state.status == SignupStatus.submitting),
                              child: const Text('Sign up'),
                            ),
                            const SizedBox(height: 12.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey[200],
                                onPrimary: Colors.black,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Back to login'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<SignupCubit>().signUpWithCredentials();
    }
  }
}
