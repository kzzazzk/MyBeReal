import 'package:animate_gradient/animate_gradient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_be_real/widgets/custom_textfield_widget.dart';

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
                    SizedBox(
                      height: 60,
                      width: 393,
                      child: ElevatedButton(
                        onPressed: () {
                          FirebaseAuth.instance.sendPasswordResetEmail(
                            email: usernameController.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                        ),
                        child: const Text('Enviar',
                            style:
                                TextStyle(fontSize: 17, color: Colors.white)),
                      ),
                    ),
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
