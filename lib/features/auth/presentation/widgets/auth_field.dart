import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final Icon? icon;
  final TextEditingController? controller;
  final bool isPassword;

  const AuthField({
    super.key,
    required this.hintText,
    this.icon,
    this.controller,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(prefixIcon: icon, hintText: hintText),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$hintText tidak boleh kosong';
        }
        return null;
      },

      obscureText: isPassword,
    );
  }
}
