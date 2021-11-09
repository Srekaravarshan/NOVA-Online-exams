import 'package:exam/models/models.dart';
import 'package:exam/repositories/repositories.dart';
import 'package:exam/screens/create_assignment/create_assignment_screen.dart';
import 'package:exam/screens/screens.dart';
import 'package:exam/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/assignments_bloc.dart';

class AssignmentsScreenArgs {
  final String classId, subjectId;

  AssignmentsScreenArgs({required this.classId, required this.subjectId});
}

class AssignmentsScreen extends StatefulWidget {
  static const String routeName = '/assignments';

  final String classId, subjectId;

  const AssignmentsScreen(
      {Key? key, required this.classId, required this.subjectId})
      : super(key: key);

  static Route route({required AssignmentsScreenArgs args}) {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => BlocProvider<AssignmentsBloc>(
              create: (_) => AssignmentsBloc(
                  storageRepository: context.read<StorageRepository>(),
                  assignmentRepository: context.read<AssignmentRepository>())
                ..add(LoadMaterials(
                    classId: args.classId, subjectId: args.subjectId)),
              child: AssignmentsScreen(
                  classId: args.classId, subjectId: args.subjectId),
            ));
  }

  @override
  _AssignmentsScreenState createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssignmentsBloc, AssignmentsState>(
      listener: (context, state) {
        print('listener status');
        print(state.status);
        if (state.status == AssignmentsStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        print('status');
        print(state.status);
        return Scaffold(
          appBar: AppBar(
              // title: Text(state.user.username),
              ),
          body: _buildBody(state),
          floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.of(context).pushNamed(
                  CreateAssignmentScreen.routeName,
                  arguments: CreateAssignmentScreenArgs(
                      classId: widget.classId, subjectId: widget.subjectId)),
              child: const Icon(Icons.add)),
        );
      },
    );
  }

  Widget _buildBody(AssignmentsState state) {
    switch (state.status) {
      case AssignmentsStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<AssignmentsBloc>().add(LoadMaterials(
                classId: widget.classId, subjectId: widget.subjectId));
          },
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.assignments.length,
            itemBuilder: (context, index) {
              final Assignment assignment = state.assignments[index];

              return buildFile(context, assignment);
            },
          ),
        );
    }
  }

  Widget buildFile(BuildContext context, Assignment assignment) => ListTile(
        title: Text(
          assignment.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
        ),
        onTap: () => Navigator.of(context).pushNamed(AssignmentScreen.routeName,
            arguments: AssignmentScreenArgs(assignment: assignment)),
      );
}
