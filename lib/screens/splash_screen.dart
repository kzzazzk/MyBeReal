import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_be_real/utils/constants.dart';

import '../firebase/firebase_messaging.dart';
import '../widgets/custom_animated_gradient.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // The connection state is still waiting. Show a loading indicator.
          return buildLoadingScreen();
        } else {
          final User? user = snapshot.data;
          if (user != null) {
            // User is logged in
            print("Logged in as ${user.email}");
            Constants.authUserEmail = user.email!;
            Messaging.sendFireBaseMessagingToken();
            return FutureBuilder<String>(
              future: getPartnerEmail(Constants.authUserEmail),
              builder: (context, partnerSnapshot) {
                if (partnerSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  // Show a loading indicator while waiting for partner's email
                  return buildLoadingScreen();
                } else if (partnerSnapshot.hasData) {
                  Constants.otherUserEmail = partnerSnapshot.data!;
                  // Redirect to HomeScreen after getting partner's email
                  Future.delayed(const Duration(seconds: 3), () {
                    Get.offNamed('/home');
                  });
                  return buildLoadingScreen();
                } else {
                  // Handle the case where partner's email is not found
                  print("No partner email found");
                  return buildErrorScreen();
                }
              },
            );
          } else {
            // User is not logged in
            // Redirect to the login screen
            Future.delayed(const Duration(seconds: 3), () {
              Get.offNamed('/login');
            });
            return buildLoadingScreen();
          }
        }
      },
    );
  }

  Widget buildLoadingScreen() {
    return const Scaffold(
      body: Stack(
        children: [
          CustomAnimatedBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'One2One.',
                  style: TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 16.0),
                CircularProgressIndicator(
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildErrorScreen() {
    return const Scaffold(
      body: Center(
        child: Text("An error occurred"),
      ),
    );
  }

  Future<String> getPartnerEmail(String email) async {
    try {
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
    } catch (e) {
      print("Error getting partner email: $e");
      return 'error';
    }
  }
}
