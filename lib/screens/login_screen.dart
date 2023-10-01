import 'package:animate_gradient/animate_gradient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_be_real/widgets/custom_textfield_widget.dart';
import 'package:typewritertext/typewritertext.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 75,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'MyBeReal',
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Roboto',
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
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
          Center(
            child: Column(
              children: [
                const SizedBox(height: 150),
                const TypeWriterText(
                  text: Text(
                    'Bienvenido/a de nuevo. \nTe echábamos de menos.',
                    maxLines: 10,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  duration: Duration(milliseconds: 50),
                ),
                const SizedBox(height: 65),
                CustomTextField(
                  controller: usernameController,
                  hintText: 'Correo electrónico',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 210,
                    bottom: 20,
                  ),
                  child: Text(
                    '¿Has olvidado tu contraseña?',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 393,
                  child: ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: usernameController.text,
                          password: passwordController.text);
                      Get.offNamed('/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Background color
                    ),
                    child: const Text('Iniciar Sesión',
                        style: TextStyle(fontSize: 17, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 50),
                /*Image.network(
                  imgUrl, // Use imgUrl to display the image
                  width: 100,
                  height: 100,
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}
