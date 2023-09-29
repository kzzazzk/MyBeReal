import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class MyButton extends StatelessWidget {
  String buttonText;
  double width = 0;
  double height = 0;
  MyButton(this.buttonText, this.width, this.height);
  @override
  Widget build(BuildContext context) {
    return GradientButton(
      callback: () {
        if (kDebugMode) {
          print('pressed');
        }
      },
      gradient: Gradients.buildGradient(Alignment.topCenter,
          Alignment.bottomCenter, [ Colors.black, Colors.black]),
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
    // TODO: implement build
    throw UnimplementedError();
  }
}
