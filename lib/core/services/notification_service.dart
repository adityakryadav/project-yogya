import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../data/remote/api_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('BG Notification: ${message.messageId}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final token = await _messaging.getToken();
    if (token != null && token.isNotEmpty) {
      await _syncToken(token);
    }

    _messaging.onTokenRefresh.listen((token) async {
      await _syncToken(token);
    });

    FirebaseMessaging.onMessage.listen((message) {
      log('Foreground notification: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log('Notification opened app: ${message.data}');
    });
  }

  Future<void> _syncToken(String token) async {
    try {
      await ApiService.instance.syncDeviceToken(token: token);
    } catch (_) {
      // Ignore token sync failures for now; app should continue to work.
    }
  }
}

