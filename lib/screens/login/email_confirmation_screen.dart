import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_be_real/widgets/custom_animated_gradient.dart';
import 'package:my_be_real/widgets/custom_appbar.dart';
import 'package:my_be_real/widgets/custom_button_widget.dart';
import 'package:my_be_real/widgets/custom_textfield_widget.dart';

class EmailConfimation extends StatelessWidget {
  EmailConfimation({Key? key}) : super(key: key);
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: Center(
        child: Stack(
          children: [
            const CustomAnimatedBackground(),
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
                      padding: screenWidth * 0.05,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                      'Enviar',
                      () {
                        FirebaseAuth.instance.sendPasswordResetEmail(
                            email: usernameController.text);
                      },
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
