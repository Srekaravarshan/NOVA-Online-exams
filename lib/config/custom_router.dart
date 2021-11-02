import 'package:exam/screens/screens.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings setting) {
    print("Route ${setting.name}");
    switch (setting.name) {
      case '/':
        return MaterialPageRoute(
            settings: const RouteSettings(name: '/'),
            builder: (_) => const Scaffold());
      case SplashScreen.routeName:
        return SplashScreen.route();
      case AuthScreen.routeName:
        return AuthScreen.route();
      case NavScreen.routeName:
        return NavScreen.route();
      case errorRouteName:
        return _errorRoute();
      // case NavScreen.routeName:
      //   return NavScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRoute(RouteSettings setting) {
    print("Nested Route ${setting.name}");
    switch (setting.name) {
      case ProfileScreen.routeName:
        return ProfileScreen.route(
            args: setting.arguments as ProfileScreenArgs);
      // case EditProfileScreen.routeName:
      //   return EditProfileScreen.route(args: setting.arguments);
      case CreateClassScreen.routeName:
        return CreateClassScreen.route();
      case ClassroomScreen.routeName:
        return ClassroomScreen.route(
            args: setting.arguments as ClassroomScreenArgs);
      case CreateSubjectScreen.routeName:
        return CreateSubjectScreen.route(
            args: setting.arguments as CreateSubjectScreenArgs);
      case CreateTimetableScreen.routeName:
        return CreateTimetableScreen.route(
            args: setting.arguments as CreateTimetableScreenArgs);
      case TimetableSubjectScreen.routeName:
        return TimetableSubjectScreen.route(
            args: setting.arguments as TimetableSubjectScreenArgs);
      default:
        return _errorRoute();
    }
  }

  static const String errorRouteName = "/error";

  static Route _errorRoute() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: errorRouteName),
        builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(
                child: Text('Something went wrong!'),
              ),
            ));
  }
}
