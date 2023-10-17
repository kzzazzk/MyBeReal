import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import '../utils/constants.dart';

class Messaging {
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static Future<void> sendFireBaseMessagingToken() async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((t) {
      if (t != null) {
        final tokendata = <String, String>{"push_token": t};
        FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: Constants.authUserEmail)
            .get()
            .then((QuerySnapshot querySnapshot) {
          // Assuming only one document matches the query.
          final documentReference = querySnapshot.docs.first.reference;
          documentReference.update(tokendata);
        });
      }
    });
  }

  static Future<void> sendPushNotification() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: Constants.otherUserEmail)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's at least one matching document.
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        // Access the specific attribute from the document data
        Map<String, dynamic> documentData =
            documentSnapshot.data() as Map<String, dynamic>;
        dynamic token = documentData['push_token'];
        print('Sent to: $token');

        final body = {
          "to": token,
          "notification": {"title": "Tu pareja te ha enviado una foto!"},
          "body": "Haz click para ver el feed"
        };

        // Send the push notification
        await post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                "key=${dotenv.env['FCM_SERVER_KEY']!}"
          },
          body: jsonEncode(body),
        );
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
