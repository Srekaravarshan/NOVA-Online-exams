import 'package:exam/models/models.dart';
import 'package:exam/repositories/repositories.dart';
import 'package:exam/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/question_paper_cubit.dart';

class QuestionPaperScreenArgs {
  final Class classroom;
  final int setIndex;

  QuestionPaperScreenArgs({required this.classroom, required this.setIndex});
}

class QuestionPaperScreen extends StatelessWidget {
  static const String routeName = '/createQuestionPaper';

  static Route route({required QuestionPaperScreenArgs args}) {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (_, __, ___) => BlocProvider<QuestionPaperBloc>(
              create: (context) => QuestionPaperBloc(
                  questionPaperRepository:
                      context.read<QuestionPaperRepository>())
                ..add(QuestionPaperLoadUser(
                    classroom: args.classroom, setIndex: args.setIndex)),
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
          title: const Text('Question paper'),
        ),
        bottomNavigationBar: Container(
            decoration: const BoxDecoration(color: Colors.white),
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InkWell(
                      onTap: () {},
                      child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.add, size: 24))),
                  InkWell(
                      onTap: () {},
                      child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.text_fields_outlined, size: 24))),
                  InkWell(
                      onTap: () {},
                      child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.image_outlined, size: 24))),
                  InkWell(
                      onTap: () {},
                      child: const Padding(
                          padding: EdgeInsets.all(12),
                          child:
                              Icon(Icons.video_collection_outlined, size: 24))),
                  InkWell(
                      onTap: () {},
                      child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.splitscreen_outlined, size: 24))),
                ],
              ),
            )),
        body: BlocConsumer<QuestionPaperBloc, QuestionPaperState>(
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.sections.length,
                              itemBuilder: (sectionContext, sectionIndex) =>
                                  Container(
                                child: Column(
                                  children: [
                                    Text(state.sections[sectionIndex].title),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: state.sections[sectionIndex]
                                          .questions.length,
                                      itemBuilder:
                                          (questionContext, questionIndex) =>
                                              _questionWidget(
                                                  type: state
                                                      .sections[sectionIndex]
                                                      .questions[questionIndex]
                                                      .type,
                                                  question: state
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
            decoration: const InputDecoration(hintText: 'Class name'),
            onChanged: (value) => context
                .read<QuestionPaperBloc>()
                .questionChanged(
                    value: value,
                    sectionIndex: sectionIndex,
                    questionIndex: questionIndex),
          ),
          _questionChoiceWidget(type)
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
