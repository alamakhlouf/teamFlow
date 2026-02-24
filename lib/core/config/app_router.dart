import 'package:flutter/material.dart';
import 'package:team_flow/core/widgets/route_not_found.dart';
import 'package:team_flow/features/auth/presentation/screens/reset_password.dart';
import 'package:team_flow/features/home/presentation/screens/home_screen.dart';

import '../../features/auth/presentation/screens/login_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/resetPassword':
        return MaterialPageRoute(builder: (_) => ResetPassword());

      default:
        return MaterialPageRoute(builder: (_) => RouteNotFound());
    }
  }
}
