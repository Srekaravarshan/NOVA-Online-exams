import 'package:exam/repositories/repositories.dart';
import 'package:exam/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/auth_cubit.dart';

class AuthScreen extends StatelessWidget {
  static const String routeName = '/auth';

  static Route route() {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (context, __, ___) => BlocProvider<AuthCubit>(
              create: (context) =>
                  AuthCubit(authRepository: context.read<AuthRepository>()),
              child: AuthScreen(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthScreenStatus.error) {
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'NOVA Exam',
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey[200],
                              onPrimary: Colors.black,
                            ),
                            onPressed: () => _submitForm(context,
                                state.status == AuthScreenStatus.submitting),
                            child: const Text('Sign in with Google'),
                          ),
                        ],
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
    print("issubmitting: " + (isSubmitting ? "true" : "false"));
    if (!isSubmitting) {
      print("auth screen signin");
      context.read<AuthCubit>().signUpWithGoogle();
    }
  }
}
