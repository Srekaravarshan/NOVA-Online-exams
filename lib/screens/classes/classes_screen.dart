import 'package:exam/blocs/blocs.dart';
import 'package:exam/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens.dart';
import 'cubit/classes_cubit.dart';

class ClassesScreenArgs {
  final String userId;

  ClassesScreenArgs({required this.userId});
}

class ClassesScreen extends StatefulWidget {
  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClassesBloc, ClassesState>(listener: (context, state) {
      print('classes listener');
      print(state.status);
      print(state.classes);
      if (state.status == ClassStatus.error) {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(content: state.failure.message),
        );
      }
    }, builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Classes'),
          ),
          body: _buildBody(state),
          floatingActionButton: FloatingActionButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(CreateClassScreen.routeName),
            child: const Icon(Icons.add),
          ));
    });
  }

  Widget _buildBody(ClassesState state) {
    switch (state.status) {
      case ClassStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<ClassesBloc>().add(ClassesLoadUser(
                userId: context.read<AuthBloc>().state.user!.uid));
          },
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) => InkWell(
              onTap: () {
                print('ontap class');
                print(state.classes[index].id);
                print(state.classes[index].name);
                Navigator.of(context).pushNamed(ClassroomScreen.routeName,
                    arguments:
                        ClassroomScreenArgs(classId: state.classes[index].id));
              },
              child: ListTile(
                title: Text(state.classes[index].name),
                subtitle: Text(state.classes[index].section ?? ''),
              ),
            ),
            shrinkWrap: true,
            itemCount: state.classes.length,
          ),
        );
    }
  }
}
