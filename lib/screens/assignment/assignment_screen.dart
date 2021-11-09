import 'package:exam/models/models.dart';
import 'package:exam/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/assignment_cubit.dart';

class AssignmentScreenArgs {
  final Assignment assignment;

  AssignmentScreenArgs({required this.assignment});
}

class AssignmentScreen extends StatefulWidget {
  static const String routeName = '/assignment';

  final Assignment assignment;

  const AssignmentScreen({Key? key, required this.assignment})
      : super(key: key);

  static Route route({required AssignmentScreenArgs args}) {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => BlocProvider<AssignmentCubit>(
              create: (_) => AssignmentCubit(),
              child: AssignmentScreen(assignment: args.assignment),
            ));
  }

  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssignmentCubit, AssignmentState>(
      listener: (context, state) {
        if (state.status == AssignmentStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.assignment.title),
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(AssignmentState state) {
    switch (state.status) {
      case AssignmentStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.assignment.materials.length,
          itemBuilder: (context, index) {
            final FirebaseFile file = widget.assignment.materials[index];

            return buildFile(context, file);
          },
        );
    }
  }

  Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
        title: Text(
          file.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
        ),
        onTap: () => {},
      );
}
