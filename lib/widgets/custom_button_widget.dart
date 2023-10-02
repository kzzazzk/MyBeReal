import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final VoidCallback onPressed;

  CustomButton(this.text, this.width, this.height, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed, // Corrected onPressed callback
        child: Text(text),
      ),
    );
  }
}
