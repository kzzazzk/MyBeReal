import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_be_real/bloc/auth/auth_bloc.dart';
import 'package:my_be_real/screens/login/email_confirmation_screen.dart';
import 'package:my_be_real/widgets/custom_loading_indicator_widget.dart';
import 'package:my_be_real/widgets/custom_textfield_widget.dart';
import 'package:typewritertext/typewritertext.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../../widgets/custom_snackbar.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
            fontWeight: FontWeight.bold,
            fontSize: 27,
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
              child: BlocConsumer<AuthBloc, AuthState>(
            listener: (BuildContext context, AuthState state) {
              if (state is Authenticated) {
                Get.offNamed('/home');
                showCustomSnackbar(
                  'Bienvenido/a de nuevo!',
                  'Has iniciado sesión con éxito.',
                  SnackPosition.TOP,
                  Colors.greenAccent,
                  const Icon(Icons.check, color: Colors.white),
                );
              } else if (state is AuthError) {
                showCustomSnackbar(
                  state.errorType,
                  state.errorMessage ?? '',
                  SnackPosition.TOP,
                  Colors.redAccent,
                  const Icon(Icons.error, color: Colors.white),
                );
              }
            },
            builder: (BuildContext context, AuthState state) {
              if (state is Loading) {
                return const CustomLoadingIndicator();
              } else {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 180),
                      child: SizedBox(
                        width: 500.0,
                        height: 70,
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ),
                          child: AnimatedTextKit(
                            stopPauseOnTap: true,
                            repeatForever: true,
                            pause: Duration(milliseconds: 5000),
                            animatedTexts: [
                              TypewriterAnimatedText(
                                  'Bienvenido/a de nuevo.\n Te echábamos de menos.',
                                  cursor: '_',
                                  speed: const Duration(milliseconds: 150),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                    CustomTextField(
                      controller: usernameController,
                      hintText: 'Correo electrónico',
                      obscureText: false,
                      padding: screenWidth * 0.05,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: passwordController,
                      hintText: 'Contraseña',
                      obscureText: true,
                      padding: screenWidth * 0.05,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 12,
                        left: 180,
                        bottom: 12,
                      ),
                      child: RichText(
                        text: TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: ((context) =>
                                        EmailConfimation())));
                              },
                            text: "¿Has olvidado tu contraseña?",
                            style: const TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.90,
                      height: screenHeight * 0.07,
                      child: ElevatedButton(
                        onPressed: () {
                          authBloc.add(SignInRequested(usernameController.text,
                              passwordController.text));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text('Iniciar sesión',
                            style:
                                TextStyle(fontSize: 17, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 50),
                    /*Image.network(
                  imgUrl, // Use imgUrl to display the image
                  width: 100,
                  height: 100,
                ),*/
                  ],
                );
              }
            },
          )),
        ],
      ),
    );
  }
}
