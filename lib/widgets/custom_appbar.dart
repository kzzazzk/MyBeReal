import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        iconTheme:
            const IconThemeData(color: Colors.white), // Change the color here
        centerTitle: true,
        toolbarHeight: 75,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'One2One.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 27,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(
      75); // Set the preferred height of your custom app bar
}
