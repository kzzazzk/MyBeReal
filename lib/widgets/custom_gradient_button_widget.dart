import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class CustomGradientButton extends StatelessWidget {
  final String buttonText;
  final double width;
  final double height;
  const CustomGradientButton(this.buttonText, this.width, this.height,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      callback: () {
        if (kDebugMode) {
          print('pressed');
        }
      },
      gradient: Gradients.buildGradient(Alignment.topCenter,
          Alignment.bottomCenter, [Colors.black, Colors.black]),
      shadowColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      increaseHeightBy: height,
      increaseWidthBy: width,
      child: Text(buttonText,
          style: const TextStyle(
            fontSize: 17,
          )),
    );
  }
}
