import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:my_be_real/bloc/auth/auth_bloc.dart';
import 'package:my_be_real/screens/login/email_confirmation_screen.dart';
import 'package:my_be_real/widgets/custom_animated_gradient.dart';
import 'package:my_be_real/widgets/custom_appbar.dart';
import 'package:my_be_real/widgets/custom_button_widget.dart';
import 'package:my_be_real/widgets/custom_loading_indicator_widget.dart';
import 'package:my_be_real/widgets/custom_textfield_widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../firebase/firebase_messaging.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_snackbar.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          const CustomAnimatedBackground(),
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
                      padding: const EdgeInsets.only(top: 155, bottom: 55),
                      child: SizedBox(
                        width: 500.0,
                        height: 70,
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 27.0,
                          ),
                          child: AnimatedTextKit(
                            stopPauseOnTap: true,
                            repeatForever: true,
                            pause: const Duration(milliseconds: 2500),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CustomTextField(
                        controller: usernameController,
                        hintText: 'Correo electrónico',
                        obscureText: false,
                        padding: screenWidth * 0.05,
                      ),
                    ),
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
                    CustomButton('Iniciar sesión', () {
                      signInButtonOnClick(authBloc);
                    }),
                  ],
                );
              }
            },
          )),
        ],
      ),
    );
  }

  Future<String> getPartnerEmail(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('partner', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot document = querySnapshot.docs.first;
      return document.get('email');
    } else {
      print("No email has been found");
      return 'noemailfound';
    }
  }

  Future<void> signInButtonOnClick(AuthBloc authBloc) async {
    Constants.authUserEmail = usernameController.text;
    Constants.otherUserEmail = await getPartnerEmail(usernameController.text);
    authBloc
        .add(SignInRequested(usernameController.text, passwordController.text));
    Messaging.sendFireBaseMessagingToken();
  }
}
