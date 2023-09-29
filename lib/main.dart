
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_be_real/screens/app_router_screen.dart';
import 'firebase_options.dart';
import 'package:typewritertext/typewritertext.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:animate_gradient/animate_gradient.dart';
import 'package:my_be_real/GradientButton.dart';
import 'package:my_be_real/MyTextField.dart';
String user = '';
String imgUrl = '';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Reference storageRef = FirebaseStorage.instance.ref();
  Reference zakaLogoRef = storageRef.child("0/ZakaLogo.png");
  imgUrl = await zakaLogoRef.getDownloadURL();
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      //routerConfig: router,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: 75,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: buildAppBarTitle(),
    );
  }

  Center buildAppBarTitle() {
    return const Center(
      child: Text(
        'MyBeReal.',
        style: TextStyle(
          fontSize: 25,
          fontFamily: 'Roboto',
          color: Colors.white,
        ),
      ),
    );
  }

  Stack buildBody() {
    return Stack(
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
          child: buildColumn(),
        ),
      ],
    );
  }

  Column buildColumn() {
    return Column(
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
        MyTextField(
          controller: usernameController,
          hintText: 'Correo electrónico',
          obscureText: false,
        ),
        const SizedBox(height: 10),
        MyTextField(
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
          child: buildForgotPassword(),
        ),
        buildSignInButton(),
        const SizedBox(height: 50),
        buildImage(),
      ],
    );
  }

  Text buildForgotPassword() {
    return const Text(
      '¿Has olvidado tu contraseña?',
      style: TextStyle(
        color: Colors.black,
      ),
    );
  }

  GradientButton buildSignInButton() {
    return GradientButton(
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
    );
  }

  Container buildImage() {
    return Container(
      child: Image.network(
        imgUrl, // Use imgUrl to display the image
        width: 100,
        height: 100,
      ),
    );
  }
}
