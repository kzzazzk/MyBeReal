import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_be_real/dependencies/initial_dependencies.dart';
import 'package:my_be_real/routes/routes.dart';

String user = '';
String imgUrl = '';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /*Reference storageRef = FirebaseStorage.instance.ref();
  Reference zakaLogoRef = storageRef.child("0/ZakaLogo.png");
  imgUrl = await zakaLogoRef.getDownloadURL();*/

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: RoutesClass.routes,
      initialBinding: InitialDependencies(),
      initialRoute: RoutesClass.getSplashScreen(),
      theme: ThemeData(
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      title: 'MyBeReal',
    );
  }
}
