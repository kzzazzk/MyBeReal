import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackbar(
  String title,
  String message,
  SnackPosition position, [
  Color color = Colors.greenAccent,
  Widget? icon,
]) {
  Get.snackbar(
    title,
    message,
    icon: icon,
    snackPosition: position, // Customize the position
    backgroundColor: color, // Customize the background color
    colorText: Colors.white, // Customize the text color
    duration: const Duration(seconds: 3), // Customize the duration
  );
}
