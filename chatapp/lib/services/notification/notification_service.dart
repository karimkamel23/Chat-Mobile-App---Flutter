// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static const List<String> scopes = [
    'https://www.googleapis.com/auth/firebase.messaging'
  ];

  final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

  Future<String> getAccessToken() async {
    // Load Firebase service account JSON file

    // get json file
    final serviceAccountJson = {
      //////////////////////////REMOVED FOR GITHUB//////////////////////////////////
      // Please contact me with any inquries about how to get and use this  json file.
      'email': 'karimkamel23@gmail.com',
    };

    // Create GoogleCredentials from service account JSON
    final credentials = ServiceAccountCredentials.fromJson(serviceAccountJson);

    // Create AuthClient using GoogleCredentials
    final client = await clientViaServiceAccount(credentials, scopes);

    // Get access token from credentials
    final accessToken = (client.credentials).accessToken.data;

    // Return access token value
    return accessToken;
  }

  void _initLocalNotification() {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      requestCriticalPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    flutterLocalNotificationPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (response) {
      debugPrint(response.payload.toString());
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final styleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title,
      htmlFormatTitle: true,
    );

    final androidDetails = AndroidNotificationDetails(
      'com.example.chatapp.urgent',
      'chatapp',
      importance: Importance.max,
      styleInformation: styleInformation,
      priority: Priority.max,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await flutterLocalNotificationPlugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
      payload: message.data['body'],
    );
  }

  Future<void> requestPermission() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional  permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    _saveToken(token!);
  }

  Future<void> _saveToken(String token) async =>
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'token': token}, SetOptions(merge: true));

  String receiverToken = '';

  Future<void> getReceiverToken(String? receiverID) async {
    final getToken = await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverID)
        .get();

    receiverToken = await getToken.data()!['token'];
  }

  Future<void> setupInteractedMessage(BuildContext context) async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage, context);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => _handleMessage(message, context));
  }

  void _handleMessage(RemoteMessage message, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          receiverUsername: message.data["senderUsername"],
          receiverID: message.data["senderId"],
        ),
      ),
    );
  }

  void firebaseNotification(context) {
    _initLocalNotification();

    setupInteractedMessage(context);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      await _showLocalNotification(message);
    });
  }

  Future<void> sendNotification({
    required String body,
    required String senderId,
    required String senderUsername,
  }) async {
    try {
      await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/chatapp-c7e12/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await getAccessToken()}',
        },
        body: jsonEncode(
          <String, dynamic>{
            "message": {
              "token": receiverToken,
              "notification": <String, dynamic>{
                "title": 'New Message from $senderUsername!',
                "body": body,
              },
              "data": <String, String>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'senderId': senderId,
                'senderUsername': senderUsername,
              },
            }
          },
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
