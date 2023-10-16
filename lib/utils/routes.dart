import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:my_be_real/screens/home_screen.dart';
import 'package:my_be_real/screens/login/login_screen.dart';
import 'package:my_be_real/screens/splash_screen.dart';

import '../screens/profile_screen.dart';

class RoutesClass {
  static String splashScreen = '/splash';
  static String loginScreen = '/login';
  static String homeScreen = '/home';
  static String profileScreen = '/profile';

  static String getSplashScreen() => '/splash';
  static String getLoginScreen() => '/login';
  static String getHomeScreen() => '/home';
  static String getProfileScreen() => '/profile';

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    GetPage(name: profileScreen, page: () => ProfileScreen()),
  ];
}
