import 'package:flutter/material.dart';

class AppInputField extends StatelessWidget {
  const AppInputField({
    super.key,
    this.text,
    required this.hintText,
    required this.textEditingController,
    this.isPassword = false,
  });

  final String? text;
  final String hintText;
  final TextEditingController textEditingController;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (text != null) ...[Text(text!), SizedBox(height: 4)],
        TextFormField(
          controller: textEditingController,
          obscureText: isPassword,
          decoration: InputDecoration(
            fillColor: Color(0xFFF1F4FF),
            hintStyle: TextStyle(
              color: Color(0xFF626262),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            hintText: hintText,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF5F33E1)),
            ),
            filled: true,
          ),
        ),
      ],
    );
  }
}
