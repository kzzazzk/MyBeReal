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
        final tokendata = <String, String>{"token": t};
        FirebaseFirestore.instance
            .collection('push_notifications')
            .doc(Constants.authUserEmail)
            .set(tokendata);
      }
    });
  }

  static Future<void> sendPushNotification() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('push_notifications')
          .doc(Constants.otherUserEmail)
          .get();
      if (documentSnapshot.exists) {
        // Access the specific attribute from the document data
        Map<String, dynamic> documentData =
            documentSnapshot.data() as Map<String, dynamic>;
        dynamic token = documentData['token'];
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
