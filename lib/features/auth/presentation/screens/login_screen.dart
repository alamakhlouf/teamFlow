import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_flow/features/auth/presentation/widget/app_input_field.dart';

import '../bloc/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              padding: EdgeInsets.all(24),
              height: MediaQuery.sizeOf(context).height / 2,
              width: MediaQuery.sizeOf(context).width,
              color: Color(0xFF5F33E1),
              child: Column(
                children: [
                  SizedBox(height: 32),
                  Text(
                    "Sign in to your Account",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Enter your email and password to log in ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height / 2,
            child: Container(
              height: MediaQuery.sizeOf(context).height / 2,
              width: MediaQuery.sizeOf(context).width,
              color: Color(0xFFF6F8FA),
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height / 4,
            left: 24,
            right: 24,
            child: Container(
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
              height: MediaQuery.sizeOf(context).height / 2,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: AppInputField(
                      text: "Email",
                      hintText: "Email",
                      textEditingController: emailController,
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: AppInputField(
                      text: "Password",
                      hintText: "Password",
                      textEditingController: passwordController,
                      isPassword: true,
                    ),
                  ),
                  SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<AuthBloc>(context).add(
                          AuthLogin(
                            email: emailController.text,
                            password: passwordController.text,
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsetsGeometry.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFF5F33E1),
                        ),
                        child: Center(
                          child: BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is AuthSuccess) {
                                if (state.appUserModel != null &&
                                    state.appUserModel!.firstLogin) {
                                  Navigator.pushNamed(
                                    context,
                                    '/resetPassword',
                                  );
                                } else {
                                  Navigator.pushNamed(context, '/home');
                                }
                              }
                            },
                            builder: (context, state) {
                              return state is AuthLoading
                                  ? SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      "Login",
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
