import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE0E0E0))),
            fillColor: Colors.black45,
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
