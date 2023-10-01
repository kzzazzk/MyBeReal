import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_be_real/screens/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3)).then(
      (value) => Get.off(LoginScreen(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInCubic,
          fullscreenDialog: true,
          preventDuplicates: true),
    );
    return Scaffold(
      body: Stack(
        children: [
          AnimateGradient(
            primaryColors: const [
              Color(0xFF96d4ca),
              Color(0xFF7c65a9),
            ],
            secondaryColors: const [
              Color(0xFF7c65a9),
              Color(0XFFf5ccd4),
            ],
          ),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /*Image(
                  image: AssetImage('assets/logo.jpeg'),
                  height: 128.0,
                  width: 128.0),*/
                Text(
                  'MyBeReal.',
                  style: TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
                SizedBox(height: 16.0),
                CircularProgressIndicator(
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
