import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';

class CustomAnimatedBackground extends StatelessWidget {
  const CustomAnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimateGradient(primaryColors: const [
      Color(0xFF96d4ca),
      Color(0xFF7c65a9),
    ], secondaryColors: const [
      Color(0xFF7c65a9),
      Color(0XFFf5ccd4),
    ]);
  }
}
