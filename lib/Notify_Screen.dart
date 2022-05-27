import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class PushNotify {
  PushNotify({this.title, this.body, this.dataBody, this.dataTitle});
  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final FirebaseMessaging? messaging;
  PushNotify? notify;

  void registerMessage() async {
    messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging!.requestPermission(
      sound: true,
      provisional: false,
      badge: true,
      alert: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("you are granted for notification");

      FirebaseMessaging.onMessage.listen((event) {
        PushNotify pushNotify = PushNotify(
            title: event.notification?.title,
            body: event.notification?.body,
            dataBody: event.data['body'],
            dataTitle: event.data["title"]);
        setState(() {
          notify = pushNotify;
        });
        if (pushNotify != null) {
          showSimpleNotification(
            Text(pushNotify.title!),
            subtitle: Text(pushNotify.body!),
            duration: const Duration(seconds: 1),
            background: Colors.blueGrey,
          );
        } else {
          log('User declined or has not accepted permission');
        }
      });
    }
  }

  void backGroundMessage() {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      PushNotify pushNotify = PushNotify(
          body: event.notification!.body,
          title: event.notification!.title,
          dataTitle: event.data["title"],
          dataBody: event.data["body"]);
      setState(() {
        notify = pushNotify;
      });
    });
  }

  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((String? token) {
      log("Token=========$token");
    });
    backGroundMessage();

    registerMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Flutter PushNotification",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          notify != null
              ? Column(
                  children: [
                    Text(
                      "TITLE: ${notify?.title}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    Text(
                      "BODY: ${notify?.body}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    )
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
