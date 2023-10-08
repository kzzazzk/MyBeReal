import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_be_real/bloc/auth/auth_bloc.dart';
import 'package:my_be_real/firebase/firebase_options.dart';
import 'package:my_be_real/repositories/auth_repository.dart';
import 'package:my_be_real/utils/routes.dart';

void main() async {
  HttpOverrides.global = PostHttpOverrides();
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      create: (context) => AuthRepository(),
      child: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
        ),
        child: GetMaterialApp(
          supportedLocales: const [
            Locale('es', 'ES'),
          ],
          locale: const Locale('es', 'ES'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          title: 'MyBeReal.',
          theme: ThemeData(
              useMaterial3: true, fontFamily: GoogleFonts.lato().fontFamily),
          initialRoute: '/splash',
          getPages: RoutesClass.routes,
        ),
      ),
    );
  }
}

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
