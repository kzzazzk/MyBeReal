import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final double padding;

  const CustomTextField(
      {super.key,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      required this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: padding, // 5%
        right: padding, // 5%
      ),
      child: TextField(
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE0E0E0))),
            fillColor: Colors.black54,
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
