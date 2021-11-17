import 'package:exam/models/models.dart';
import 'package:exam/repositories/repositories.dart';
import 'package:exam/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens.dart';
import 'bloc/classroom_bloc.dart';

class ClassroomScreenArgs {
  final String classId;

  ClassroomScreenArgs({required this.classId});
}

class ClassroomScreen extends StatefulWidget {
  static const String routeName = '/classroom';
  final String classId;

  const ClassroomScreen({Key? key, required this.classId}) : super(key: key);

  static Route route({required ClassroomScreenArgs args}) {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (_, __, ___) => BlocProvider<ClassroomBloc>(
              create: (context) => ClassroomBloc(
                  classesRepository: context.read<ClassesRepository>())
                ..add(ClassroomLoadClass(classId: args.classId)),
              child: ClassroomScreen(classId: args.classId),
            ));
  }

  @override
  _ClassroomScreenState createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClassroomBloc, ClassroomState>(
      listener: (context, state) {
        if (state.status == ClassroomStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text(state.classroom.name),
              actions: [
                IconButton(
                  icon: const Icon(Icons.table_chart_outlined),
                  onPressed: () => Navigator.of(context).pushNamed(
                      CreateTimetableScreen.routeName,
                      arguments:
                          CreateTimetableScreenArgs(classId: widget.classId)),
                )
              ],
            ),
            body: _buildBody(state),
            floatingActionButton: FloatingActionButton.extended(
              label: const Text('Add Subject'),
              onPressed: () => Navigator.of(context).pushNamed(
                  CreateSubjectScreen.routeName,
                  arguments: CreateSubjectScreenArgs(classId: widget.classId)),
              icon: const Icon(Icons.add),
            ));
      },
    );
  }

  Widget _buildBody(ClassroomState state) {
    switch (state.status) {
      case ClassroomStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
          onRefresh: () async {},
          child: Column(
            children: [
              addVerticalSpace(15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: false,
                  headingRowColor:
                      MaterialStateProperty.all<Color>(Colors.blue.shade50),
                  showBottomBorder: true,
                  headingTextStyle:
                      GoogleFonts.lato(fontSize: 16, color: Colors.black),
                  dataTextStyle:
                      const TextStyle(fontSize: 14, color: Colors.black87),
                  sortAscending: true,
                  sortColumnIndex: 0,
                  columns: Timetable.getTableHeaders(),
                  rows: Timetable.getTableRows(
                      state.classroom.timetable, context, state.classroom),
                ),
              ),
              addVerticalSpace(30),
              Text('Subjects',
                  style: GoogleFonts.lato(
                      fontSize: Theme.of(context).textTheme.headline5?.fontSize,
                      color: Colors.black,
                      fontStyle: FontStyle.italic)),
              addVerticalSpace(15),
              ListView.separated(
                itemBuilder: (BuildContext context, int index) => InkWell(
                  onTap: () => Navigator.of(context).pushNamed(
                      AssignmentsScreen.routeName,
                      arguments: AssignmentsScreenArgs(
                          classId: widget.classId,
                          subjectId: state.subjects[index].id)),
                  child: subjectCard(
                      title: state.subjects[index].name,
                      i: index,
                      context: context),
                ),
                shrinkWrap: true,
                itemCount: state.subjects.length,
                separatorBuilder: (BuildContext context, int index) =>
                    addVerticalSpace(15),
              ),
            ],
          ),
        );
    }
  }
}
