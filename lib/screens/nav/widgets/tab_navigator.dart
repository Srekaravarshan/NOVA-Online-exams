import 'package:exam/blocs/blocs.dart';
import 'package:exam/config/custom_router.dart';
import 'package:exam/enums/enums.dart';
import 'package:exam/repositories/repositories.dart';
import 'package:exam/screens/classes/cubit/classes_cubit.dart';
import 'package:exam/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screens.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';

  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({
    Key? key,
    required this.navigatorKey,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget Function(BuildContext)> routeBuilders =
        _routeBuilders();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
            settings: const RouteSettings(name: tabNavigatorRoot),
            builder: (context) => routeBuilders[initialRoute]!(context),
          )
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.classes:
        return BlocProvider<ClassesBloc>(
          create: (context) => ClassesBloc(
              userRepository: context.read<UserRepository>(),
              classesRepository: context.read<ClassesRepository>())
            ..add(ClassesLoadUser(
                userId: context.read<AuthBloc>().state.user!.uid)),
          child: ClassesScreen(),
        );
      case BottomNavItem.profile:
        return BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
              userRepository: context.read<UserRepository>(),
              authBloc: context.read<AuthBloc>())
            ..add(ProfileLoadUser(
                userId: context.read<AuthBloc>().state.user!.uid)),
          child: const ProfileScreen(),
        );
      default:
        return const Scaffold();
    }
  }
}
