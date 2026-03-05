import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_flow/features/profile/presentation/screens/profile_screen.dart';
import 'package:team_flow/features/projects/presentation/screens/projects_screen.dart';
import 'package:team_flow/features/users/presentation/screens/users_screen.dart';

import 'auth/presentation/bloc/auth_bloc.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key});

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<BottomNavigationBarItem> _itemsForRole(String role) {
    if (role == "user") {
      return [
        BottomNavigationBarItem(
          icon: Icon(Icons.task_alt_outlined),
          label: "Projects",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Profile"),
      ];
    } else {
      return [
        BottomNavigationBarItem(
          icon: Icon(Icons.task_alt_outlined),
          label: "Projects",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.supervised_user_circle),
          label: "Users",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Profile"),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthBloc>().state;
    if (state is! AuthSuccess) {
      Navigator.pushNamed(context, '/login');
      return Container();
    }
    final role = state.appUserModel.role;
    List<Widget> widgetOptions = (role == "user")
        ? [ProjectsScreen(), ProfileScreen()]
        : [ProjectsScreen(), UsersScreen(), ProfileScreen()];
    if (_selectedIndex >= widgetOptions.length) {
      _selectedIndex = 0;
    }
    return Scaffold(
      body: Center(child: widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: _itemsForRole(role),
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF5F33E1),
        onTap: _onItemTapped,
      ),
    );
  }
}
