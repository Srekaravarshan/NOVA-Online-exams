import 'package:exam/models/models.dart';
import 'package:exam/repositories/repositories.dart';
import 'package:exam/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens.dart';
import 'cubit/timetable_subject_cubit.dart';

class TimetableSubjectScreenArgs {
  final Class classroom;

  TimetableSubjectScreenArgs({required this.classroom});
}

class TimetableSubjectScreen extends StatefulWidget {
  static const String routeName = '/timetableSubject';
  final Class classroom;

  const TimetableSubjectScreen({Key? key, required this.classroom})
      : super(key: key);

  static Route route({required TimetableSubjectScreenArgs args}) {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (_, __, ___) => BlocProvider<TimetableSubjectCubit>(
              create: (context) => TimetableSubjectCubit(
                  classesRepository: context.read<ClassesRepository>()),
              child: TimetableSubjectScreen(classroom: args.classroom),
            ));
  }

  @override
  _TimetableSubjectScreenState createState() => _TimetableSubjectScreenState();
}

class _TimetableSubjectScreenState extends State<TimetableSubjectScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimetableSubjectCubit, TimetableSubjectState>(
      listener: (context, state) {
        if (state.status == TimetableSubjectStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text(widget.classroom.name),
            ),
            body: _buildBody(state));
      },
    );
  }

  Widget _buildBody(TimetableSubjectState state) {
    switch (state.status) {
      case TimetableSubjectStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
          onRefresh: () async {},
          child: Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.classroom.questionPapers.length,
                  itemBuilder: (context, index) => Column(children: [
                        Text(widget.classroom.questionPapers[index].set),
                        _qpButton(
                            status:
                                widget.classroom.questionPapers[index].status,
                            index: index)
                      ])),
              ElevatedButton(
                  onPressed: () => addSetDialog(state, context),
                  child: const Text("Add Set"))
            ],
          ),
        );
    }
  }

  Widget _qpButton({required String status, required int index}) {
    switch (status) {
      case 'initial':
        return TextButton(
          child: const Text('Prepare Question paper'),
          onPressed: () => Navigator.of(context).pushNamed(
              QuestionPaperScreen.routeName,
              arguments: QuestionPaperScreenArgs(
                  classroom: widget.classroom, setIndex: index)),
        );
      case 'prepared':
        return TextButton(
            onPressed: () {}, child: const Text('View Question paper'));
      default:
        return TextButton(
            onPressed: () {}, child: const Text('Prepare Question paper'));
    }
  }

  void addSetDialog(TimetableSubjectState state, BuildContext parentContext) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add set'),
        content: Container(
          child: TextFormField(
            decoration: const InputDecoration(hintText: 'Section'),
            onChanged: (value) =>
                parentContext.read<TimetableSubjectCubit>().setChanged(value),
          ),
        ),
        actions: [
          TextButton(
              child: Text('Add'),
              onPressed: () => _submit(state, parentContext))
        ],
      ),
    );
  }

  void _submit(TimetableSubjectState state, BuildContext parentContext) {
    if (state.set.trim() != '') {
      parentContext
          .read<TimetableSubjectCubit>()
          .addSet(classroom: widget.classroom);
    }
  }
}
