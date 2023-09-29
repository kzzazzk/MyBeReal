import 'package:animate_gradient/animate_gradient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
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
        toolbarHeight: 75,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'MyBeReal.',
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Roboto',
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          AnimateGradient(
            primaryColors: const [
              Color(0xFF6d42b3),
              Color(0xFFBEA9DF),
              Color(0XFFded3ee),
              Color(0Xffffffeb),
            ],
            secondaryColors: const [
              Color(0XFFFBA1B7),
              Color(0XFFFDC4D2),
              Color(0XFFFFE5E5),
              Color(0Xffffffeb),
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
                      color: Colors.black,
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
                      color: Colors.black,
                    ),
                  ),
                ),
                GradientButton(
                  callback: () {
                    FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: usernameController.text,
                      password: passwordController.text,
                    );
                    //return context.go('img_grid');
                  },
                  gradient: Gradients.buildGradient(
                    Alignment.topCenter,
                    Alignment.bottomCenter,
                    [Colors.black, Colors.black],
                  ),
                  shadowColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  increaseHeightBy: 20,
                  increaseWidthBy: 305,
                  child: const Text(
                    'Iniciar sesión',
                    style: TextStyle(
                      fontSize: 17,
                    ),
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
