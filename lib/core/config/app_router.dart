import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_flow/core/widgets/route_not_found.dart';
import 'package:team_flow/features/auth/presentation/screens/reset_password.dart';
import 'package:team_flow/features/profile/domain/profile_repo.dart';
import 'package:team_flow/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:team_flow/features/projects/data/project_model.dart';
import 'package:team_flow/features/projects/presentation/bloc/projects/projects_bloc.dart';
import 'package:team_flow/features/projects/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:team_flow/features/projects/presentation/screens/project_details_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/navigation_bar_screen.dart';
import '../../features/users/domain/users_repo.dart';
import '../../features/users/presentation/bloc/users_bloc/users_bloc.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/home':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => UsersBloc(UsersRepo())..add(UsersFetch()),
              ),

              BlocProvider(
                create: (_) => ProfileBloc(ProfileRepo())..add(GetProfile()),
              ),

              BlocProvider(create: (_) => ProjectsBloc()),
            ],
            child: AppBottomNavigationBar(),
          ),
        );
      case '/resetPassword':
        return MaterialPageRoute(builder: (_) => ResetPassword());
      case '/projectDetails':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                TasksBloc()
                  ..add(LoadTasks((settings.arguments! as ProjectModel).id)),
            child: ProjectDetailsScreen(
              project: settings.arguments! as ProjectModel,
            ),
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => RouteNotFound());
    }
  }
}
