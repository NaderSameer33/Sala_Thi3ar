import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../caching/secure_storage_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    await FcmService.showNotification(message);
  } catch (e) {
    log('Background notification error: $e');
  }
}

class FcmService {
  final SecureStorageService _secureStorage;
  String? _fcmToken;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'sala_thimar_channel_id',
    'إشعارات ثمار',
    description: 'قناة إشعارات تطبيق سلة ثمار الرسمية',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  FcmService(this._secureStorage);

  String? get fcmToken => _fcmToken;

  Future<void> init() async {
    try {
      await Firebase.initializeApp();
      final messaging = FirebaseMessaging.instance;

      await _setupLocalNotifications();

      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      messaging.onRegistered.listen((newToken) async {
        _fcmToken = newToken;
        await _secureStorage.write(SecureStorageService.keyDeviceToken, newToken);
      });

      await messaging.register();

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        showNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleMessageTap(message);
      });

      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageTap(initialMessage);
      }
    } catch (e) {
      log('FcmService init: $e');
    }

    if (_fcmToken == null || _fcmToken!.isEmpty) {
      _fcmToken = await _secureStorage.read(SecureStorageService.keyDeviceToken);
    }
  }

  static Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            final data = jsonDecode(response.payload!);
            if (data is Map<String, dynamic>) {
              _onNotificationClicked(data);
            }
          } catch (_) {}
        }
      },
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(_channel);
    }
  }

  static Future<void> showNotification(RemoteMessage message) async {
    final title = message.notification?.title ??
        message.data['title']?.toString() ??
        'إشعار من سلة ثمار';
    final body = message.notification?.body ??
        message.data['body']?.toString() ??
        message.data['message']?.toString() ??
        '';

    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    final id = message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await _localNotifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
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
