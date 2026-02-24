import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_flow/features/auth/presentation/widget/app_input_field.dart';
import '../bloc/auth_bloc.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        children: [
          /// Top Purple Section
          Positioned(
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              height: size.height / 2,
              width: size.width,
              color: const Color(0xFF5F33E1),
              child: Column(
                children: const [
                  SizedBox(height: 32),
                  Text(
                    "Change Your Password",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "For security reasons, you must change your password on first login.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          /// Bottom Background
          Positioned(
            top: size.height / 2,
            child: Container(
              height: size.height / 2,
              width: size.width,
              color: const Color(0xFFF6F8FA),
            ),
          ),

          /// Card Section
          Positioned(
            top: size.height / 4,
            left: 24,
            right: 24,
            child: Container(
              height: size.height / 2,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// New Password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: AppInputField(
                      text: "New Password",
                      hintText: "Enter new password",
                      textEditingController: passwordController,
                      isPassword: true,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Confirm Password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: AppInputField(
                      text: "Confirm Password",
                      hintText: "Re-enter password",
                      textEditingController: confirmPasswordController,
                      isPassword: true,
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GestureDetector(
                      onTap: () {
                        if (passwordController.text !=
                            confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                              Text("Passwords do not match"),
                            ),
                          );
                          return;
                        }

                        BlocProvider.of<AuthBloc>(context).add(
                          AuthChangePassword(
                            newPassword: passwordController.text,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF5F33E1),
                        ),
                        child: Center(
                          child: BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is AuthSuccess) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/home',
                                );
                              }
                              if (state is AuthError) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content:
                                    Text(state.message),
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              return state is AuthLoading
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : const Text(
                                "Update Password",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}