import 'package:animate_gradient/animate_gradient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:my_be_real/utils/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
                      Text(
                        'MyBeReal.',
                        style: TextStyle(
                            fontSize: 48.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
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
        } else {
          final User? user = snapshot.data;
          if (user != null) {
            // Esperar 3 segundos antes de redirigir a HomeScreen
            Future.delayed(const Duration(seconds: 3), () {
              Constants.authUserEmail = user.email!;
              Constants.otherUserEmail =
                  Constants.authUserEmail == dotenv.env['ZAKA_ID']
                      ? dotenv.env['ADRI_ID']!
                      : dotenv.env['ZAKA_ID']!;
              Get.offNamed('/home'); // Redirigir a HomeScreen
            });
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
                              color: Colors.white),
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
            ); // Retorna un contenedor vacío mientras se espera
          } else {
            // Esperar 3 segundos antes de redirigir a LoginScreen
            Future.delayed(const Duration(seconds: 3), () {
              Get.offNamed('/login'); // Redirigir a LoginScreen
            });
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
                        Text(
                          'MyBeReal.',
                          style: TextStyle(
                              fontSize: 48.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
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
            ); // Retorna un contenedor vacío mientras se espera
          }
        }
      },
    );
  }
}
