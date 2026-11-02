import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../caching/secure_storage_service.dart';
import 'local_notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    await FcmService.displayRemoteMessage(message);
  } catch (e) {
    log('Background message error: $e');
  }
}

class FcmService {
  final SecureStorageService _secureStorage;
  String? _fcmToken;

  FcmService(this._secureStorage);

  String? get fcmToken => _fcmToken;

  Future<void> init() async {
    try {
      await Firebase.initializeApp();
      final messaging = FirebaseMessaging.instance;

      try {
        await LocalNotificationService.init(
          onNotificationTap: _onNotificationClicked,
        );
      } catch (e) {
        log('LocalNotificationService init warning: $e');
      }

      try {
        await messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );
      } catch (e) {
        log('Notification permission request warning: $e');
      }

      try {
        await messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      } catch (e) {
        log('Foreground presentation warning: $e');
      }

      try {
        FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      } catch (e) {
        log('Background message handler warning: $e');
      }

      try {
        messaging.onRegistered.listen((newToken) async {
          _fcmToken = newToken;
          await _secureStorage.write(SecureStorageService.keyDeviceToken, newToken);
        });
        await messaging.register();
      } catch (e) {
        log('FCM register warning: $e');
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        displayRemoteMessage(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleMessageTap(message);
      });

      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageTap(initialMessage);
      }
    } catch (e) {
      log('FcmService init error: $e');
    }

    if (_fcmToken == null || _fcmToken!.isEmpty) {
      _fcmToken = await _secureStorage.read(SecureStorageService.keyDeviceToken);
    }
  }

  static Future<void> displayRemoteMessage(RemoteMessage message) async {
    final title = message.notification?.title ??
        message.data['title']?.toString() ??
        'إشعار من سلة ثمار';
    final body = message.notification?.body ??
        message.data['body']?.toString() ??
        message.data['message']?.toString() ??
        '';

    final id = message.messageId?.hashCode ??
        DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await LocalNotificationService.showNotification(
      id: id,
      title: title,
      body: body,
      payload: jsonEncode(message.data),
    );
  }

  static void _handleMessageTap(RemoteMessage message) {
    _onNotificationClicked(message.data);
  }

  static void _onNotificationClicked(Map<String, dynamic> data) {
    log('Notification clicked with payload: $data');
  }

  Future<String> getOrFetchToken() async {
    if (_fcmToken != null && _fcmToken!.isNotEmpty) {
      return _fcmToken!;
    }

    try {
      await FirebaseMessaging.instance.register();
    } catch (_) {}

    final stored = await _secureStorage.read(SecureStorageService.keyDeviceToken);
    if (stored != null && stored.isNotEmpty) {
      _fcmToken = stored;
      return stored;
    }

    const fallback = 'device_token_client_sala_thimar';
    _fcmToken = fallback;
    return fallback;
  }
}
