import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:my_be_real/screens/login_screen.dart';
import 'package:my_be_real/screens/splash_screen.dart';

class RoutesClass {
  static String splashScreen = '/splash';
  static String loginScreen = '/login';
  static String homeScreen = '/home';

  static String getSplashScreen() => '/splash';
  static String getLoginScreen() => '/login';
  static String getHomeScreen() => '/home';

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    //GetPage(name: homeScreen, page: () => HomeScreen()),
  ];
}
