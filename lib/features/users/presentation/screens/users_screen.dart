import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_flow/features/users/domain/users_repo.dart';

import '../../../auth/data/app_user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/manager_model.dart';
import '../bloc/managers_bloc/manager_bloc.dart';
import '../bloc/users_bloc/users_bloc.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          if (state is UsersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersLoaded) {
            final users = state.users;
            if (users.isEmpty) {
              return const Center(child: Text('No users yet.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tileColor: Color(0xFF5F33E1).withValues(alpha: 0.1),
                  title: Text(user.displayName),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:  context.read<AuthBloc>().state is AuthSuccess && (context.read<AuthBloc>().state as AuthSuccess).appUserModel.role == "admin" ? [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.green),
                        onPressed: () {
                          final usersBloc = context.read<UsersBloc>();
                          print(user.uid);
                          showDialog(
                            context: context,
                            builder: (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(value: usersBloc),
                                BlocProvider(
                                  create: (_) =>
                                  ManagerBloc(UsersRepo())..add(GetAllManagers(excludedId: user.uid)),
                                ),
                              ],
                              child: _CreateUserDialog(user: user,),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          context.read<UsersBloc>().add(UsersDelete(user.uid));
                        },
                      ),
                    ] : [],
                  ),
                );
              },
            );
          } else if (state is UsersError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton:context.read<AuthBloc>().state is AuthSuccess && (context.read<AuthBloc>().state as AuthSuccess).appUserModel.role == "admin" ?  FloatingActionButton(
        onPressed: () {
          final usersBloc = context.read<UsersBloc>();
          showDialog(
            context: context,
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: usersBloc),
                BlocProvider(
                  create: (_) =>
                      ManagerBloc(UsersRepo())..add(GetAllManagers()),
                ),
              ],
              child: _CreateUserDialog(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ) : null,
    );
  }
}

class _CreateUserDialog extends StatefulWidget {
  final AppUserModel? user;

  const _CreateUserDialog({this.user, super.key});

  @override
  State<_CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<_CreateUserDialog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _selectedRole = 'user';
  ManagerModel? _selectedManager;

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      _nameController.text = widget.user!.displayName;
      _emailController.text = widget.user!.email;
      _selectedRole = widget.user!.role;
      if (_selectedRole == 'user' && widget.user!.managerId != null) {
        _selectedManager = ManagerModel(
          uid: widget.user!.managerId!,
          displayName: '',
        );
      }
    }

    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final isNameValid = RegExp(r'^[a-zA-Z]{3,}$').hasMatch(name);
    final isEmailValid =
    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    final isPasswordValid = widget.user != null
        ? true
        : password.length >= 6;

    bool isFormValid = isNameValid && isEmailValid && isPasswordValid;

    if (widget.user != null) {
      final user = widget.user!;
      final hasChanged =
          name != user.displayName ||
              email != user.email ||
              _selectedRole != user.role ||
              (_selectedRole == 'user' &&
                  _selectedManager?.uid != user.managerId);
      isFormValid = isFormValid && hasChanged;
    }

    setState(() {
      _isButtonEnabled = isFormValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;
    return AlertDialog(
      title: Text(isEdit ? 'Edit User' : 'Create User'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Display Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            if (!isEdit)
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedRole,
              items: ['admin', 'manager', 'user']
                  .map((role) => DropdownMenuItem(
                value: role,
                child: Text(role),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                  if (_selectedRole != 'user') _selectedManager = null;
                  _validateForm();
                });
              },
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            const SizedBox(height: 12),
            if (_selectedRole == 'user')
              BlocBuilder<ManagerBloc, ManagerState>(
                builder: (context, state) {
                  if (state is ManagerLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is ManagerLoaded) {
                    // populate displayName for edit
                    if (isEdit &&
                        _selectedManager != null &&
                        _selectedManager!.displayName.isEmpty) {
                      _selectedManager = state.managersList.firstWhere(
                            (m) => m.uid == _selectedManager!.uid,
                        orElse: () => _selectedManager!,
                      );
                    }

                    return DropdownButtonFormField<ManagerModel>(
                      initialValue: _selectedManager,
                      items: state.managersList
                          .map((manager) => DropdownMenuItem(
                        value: manager,
                        child: Text(manager.displayName),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedManager = value;
                          _validateForm();
                        });
                      },
                      decoration:
                      const InputDecoration(labelText: 'Assign Manager'),
                    );
                  } else if (state is ManagerError) {
                    return Text('Error loading managers: ${state.error}');
                  }
                  return const SizedBox();
                },
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        BlocConsumer<UsersBloc, UsersState>(
          listener: (context, state) {
            if (state is UsersLoaded) Navigator.pop(context);
          },
          builder: (context, state) {
            if (state is UsersLoading) {
              return const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }
            return ElevatedButton(
              onPressed: _isButtonEnabled
                  ? () {
                final displayName = _nameController.text.trim();
                final email = _emailController.text.trim();
                final password = _passwordController.text;

                AppUserModel userToSave = AppUserModel(
                  uid: isEdit ? widget.user!.uid : '',
                  email: email,
                  displayName: displayName,
                  role: _selectedRole,
                  firstLogin: isEdit ? widget.user!.firstLogin : true,
                );

                if (_selectedRole == 'user' && _selectedManager != null) {
                  userToSave = userToSave.copyWith(
                      managerId: _selectedManager!.uid);
                }

                if (isEdit) {
                  context.read<UsersBloc>().add(UsersUpdate(userToSave));
                } else {
                  context.read<UsersBloc>()
                      .add(UsersAdd(userToSave, password));
                }
              }
                  : null,
              child: Text(isEdit ? 'Update' : 'Create'),
            );
          },
        ),
      ],
    );
  }
}