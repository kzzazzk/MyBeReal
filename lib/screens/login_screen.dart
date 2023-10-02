import 'package:animate_gradient/animate_gradient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_be_real/widgets/custom_button_widget.dart';
import 'package:my_be_real/widgets/custom_textfield_widget.dart';
import 'package:typewritertext/typewritertext.dart';

class LoginScreen extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  LoginScreen({super.key});

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
          'MyBeReal.',
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
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 210,
                    bottom: 20,
                  ),
                  child: RichText(
                    text: TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => EmailConfimation())));
                          },
                        text: "¿Has olvidado tu contraseña?",
                        style: const TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ),
                CustomButton(
                    'Iniciar sesión',
                    393,
                    60,
                    signInCallback(
                        usernameController.text, passwordController.text)),
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

class EmailConfimation extends StatelessWidget {
  EmailConfimation({Key? key}) : super(key: key);
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
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
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: Stack(
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
            Padding(
              padding: const EdgeInsets.only(top: 125),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10, left: 22),
                      child: Text(
                        'Introduce tu correo electrónico para reestablecer tu contraseña',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    CustomTextField(
                      hintText: 'Correo electrónico',
                      obscureText: false,
                      controller: usernameController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomButton('Enviar', 393, 60,
                        resetPasswordCallback(usernameController.text)),
                    const Spacer()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

VoidCallback signInCallback(String username, String password) {
  return () {
    signIn(username, password);
  };
}

VoidCallback resetPasswordCallback(String username) {
  return () {
    resetPassword(username);
  };
}

void signIn(String username, String password) {
  try {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: username, password: password)
        .then((value) => Get.offNamed('/home'));
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    } else {
      print('There has been an error');
    }
  }
}

void resetPassword(String email) {
  try {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } catch (e) {
    print("Password reset failed: $e");
  }
}
