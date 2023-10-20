import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const CustomButton(this.text, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.90,
      height: MediaQuery.of(context).size.height * 0.07,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(text,
            style: const TextStyle(fontSize: 17, color: Colors.white)),
      ),
    );
  }
}
