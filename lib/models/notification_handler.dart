import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext context;

  void setUpFirebase(BuildContext context) {
    this.context = context;
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@drawable/logo');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessagingListeners();
  }

  Future _showNotificationWithDefaultSound(String title, String message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'app.msquare', 'motorcity', 'motorcity',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      '$title',
      '$message',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
    });
    _firebaseMessaging.subscribeToTopic("all");

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        final notification = message['notification'];

        final title = notification['title'];
        final body = notification['body'];
        _showNotificationWithDefaultSound(title, body);
        print("Geet Hna");
      },
      onResume: (Map<String, dynamic> message) async {
        print("la2 Geet Hna");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("lalala ana Geet Hna");
      },
    );
  }
  
  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}
