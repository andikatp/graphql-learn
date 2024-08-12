import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';

class FcmService {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<String> _getAccessToken() async {
    try {
      const firebaseMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      final serviceAccount =
          await rootBundle.loadString('./assets/dgmi-hrm-firebase-token.json');

      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(serviceAccount),
        [firebaseMessagingScope],
      );

      final accessToken = client.credentials.accessToken.data;
      return accessToken;
    } catch (e) {
      throw Exception('Error getting access token: $e');
    }
  }

  Future<bool> sendNotification({
    required String recipientFCMToken,
    required String title,
    required String body,
  }) async {
    final accessToken = await _getAccessToken();
    const projectId = 'dgmi-hrm';
    const fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/$projectId';
    const url = '$fcmEndpoint/messages:send';

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final reqBody = jsonEncode(
      {
        'message': {
          'token': recipientFCMToken,
          'notification': {'body': body, 'title': title},
          'android': {
            'notification': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            },
          },
          'apns': {
            'payload': {
              'aps': {'category': 'NEW_NOTIFICATION'},
            },
          },
        },
      },
    );
    final dio = Dio();

    try {
      final response = await dio.post<Map<String, dynamic>>(
        url,
        options: Options(headers: headers),
        data: reqBody,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  Future<void> initFcm() async {
    const channel = AndroidNotificationChannel(
      'fcm_default_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon,
            ),
          ),
        );
      }
    });
  }
}


// main

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      FlavorConfig();
      await Permission.notification.isDenied.then((value) {
        if (value) {
          Permission.notification.request();
        }
      });
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
      await Global.init();
      await FcmService().initFcm();
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      await SentryFlutter.init(
        (options) {
          options
            ..dsn =
                'https://4986bef9988f4206ada3da6ca9372877@o4504761344983040.ingest.sentry.io/4504761490472960'
            ..tracesSampleRate = 1.0;
        },
        appRunner: () => runApp(const MyApp()),
      );
    },
    (error, stack) => 
    FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: true,
    ),
  );
}
