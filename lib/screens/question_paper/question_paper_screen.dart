import 'package:exam/repositories/repositories.dart';
import 'package:exam/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/question_paper_cubit.dart';

class QuestionPaperScreen extends StatelessWidget {
  static const String routeName = '/createClass';

  static Route route() {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (_, __, ___) => BlocProvider<QuestionPaperCubit>(
              create: (context) => QuestionPaperCubit(
                  questionPaperRepository:
                      context.read<QuestionPaperRepository>()),
              child: QuestionPaperScreen(),
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
        body: BlocConsumer<QuestionPaperCubit, QuestionPaperState>(
          listener: (context, state) {
            if (state.status == QuestionPaperStatus.success) {
              // _formKey.currentState?.reset();
              // context.read<QuestionPaperCubit>().reset();

              Scaffold.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 1),
                  content: Text('Class Created'),
                ),
              );
            } else if (state.status == QuestionPaperStatus.error) {
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
                  if (state.status == QuestionPaperStatus.submitting)
                    const LinearProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // TextFormField(
                          //   decoration: InputDecoration(hintText: 'Class name'),
                          //   onChanged: (value) => context
                          //       .read<QuestionPaperCubit>()
                          //       .nameChanged(value),
                          //   validator: (value) => value!.trim().isEmpty
                          //       ? 'Name cannot be empty.'
                          //       : null,
                          // ),
                          ListView.builder(
                            itemCount: state.questionPaper.sections.length,
                            itemBuilder: (sectionContext, sectionIndex) =>
                                Container(
                              child: Column(
                                children: [
                                  Text(state.questionPaper
                                      .sections[sectionIndex].title),
                                  ListView.builder(
                                    itemCount: state
                                        .questionPaper
                                        .sections[sectionIndex]
                                        .questions
                                        .length,
                                    itemBuilder: (questionContext,
                                            questionIndex) =>
                                        _questionWidget(
                                            type: state
                                                .questionPaper
                                                .sections[sectionIndex]
                                                .questions[questionIndex]
                                                .questionType,
                                            question: state
                                                .questionPaper
                                                .sections[sectionIndex]
                                                .questions[questionIndex]
                                                .question,
                                            sectionIndex: sectionIndex,
                                            questionIndex: questionIndex,
                                            context: context),
                                  )
                                ],
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

  Widget _questionWidget(
      {required String type,
      required Map question,
      required int sectionIndex,
      required int questionIndex,
      required BuildContext context}) {
    return Container(
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(hintText: 'Class name'),
            onChanged: (value) => context
                .read<QuestionPaperCubit>()
                .questionChanged(
                    value: value,
                    sectionIndex: sectionIndex,
                    questionIndex: questionIndex),
          ),
        ],
      ),
    );
  }

  Widget _questionChoiceWidget(String type) {
    switch (type) {
      case 'option':
        return Container();
      default:
        return Container();
    }
  }
}
