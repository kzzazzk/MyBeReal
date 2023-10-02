import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:my_be_real/bloc/auth_bloc.dart';
import 'package:my_be_real/firebase_options.dart';
import 'package:my_be_real/repositories/auth_repository.dart';
import 'package:my_be_real/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        ),
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Core Dumped APP',
          theme: ThemeData(
            useMaterial3: true,
          ),
          initialRoute: '/splash',
          getPages: RoutesClass.routes,
        ),
      ),
    );
  }
}
