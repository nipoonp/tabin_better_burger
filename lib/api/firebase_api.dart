import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // Request permission for notifications
    await _firebaseMessaging.requestPermission();

    // Retrieve the FCM token
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');

    // Send the FCM token to your email
    if (fCMToken != null) {
      await sendFcmTokenToEmail(fCMToken);
    }
  }

  Future<void> sendFcmTokenToEmail(String fCMToken) async {
    const String apiUrl =
        'https://y0gnh04vva.execute-api.ap-southeast-2.amazonaws.com/prod'; // Replace with your Lambda API URL

    final emailPayload = {
      "to": "nipoon@tabin.co.nz", // Recipient email
      "from": {
        "name": "Flutter App",
        "email": "no-reply@tabin.co.nz" // Replace with your sender email
      },
      "subject": "New FCM Token",
      "text": "Here is the new FCM token: $fCMToken",
      "html": "<p>Here is the new FCM token: <strong>$fCMToken</strong></p>",
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(emailPayload),
      );

      if (response.statusCode == 200) {
        print("Email sent successfully");
      } else {
        print("Failed to send email: ${response.body}");
      }
    } catch (e) {
      print("Error sending email: $e");
    }
  }
}
