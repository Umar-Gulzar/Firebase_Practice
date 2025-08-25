import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:app_settings/app_settings.dart';

class NotificationServices
{
  FirebaseMessaging messaging=FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission()async
  {
    NotificationSettings settings=await messaging.requestPermission(
      alert: true, ///agar ya true tab hi screen par notification show ho ga lakin aagr ya false ho ga
      ///tu permission grant karny par bhi ya show na ho ga.
      announcement: true,
      badge: true,///app icon par indicator show ho rahy hoty han jessy 1,2,3..
      carPlay: true,
      criticalAlert: true,
      provisional: true, ///turn off/turn on option iphone ma
      sound: true,
    );

    if(settings.authorizationStatus==AuthorizationStatus.authorized)
      {
        print("User granted Permission");
      }
    else if(settings.authorizationStatus==AuthorizationStatus.provisional)
    {                                        ///ya iphoneky liya han provisional permission aur uppar wali android ky liya.
      print("User granted provisional Permission");
    }
    else
      {
        print("User denied Permission");
      }

  }

  Future<String?> getDeviceToken()async
  {
    return await messaging.getToken();
  }

  ///Token can expire
///so we check new token when token will refresh and then we take action like add new tioken in firebase console messaging.
void isTokenRefresh()async
{
  messaging.onTokenRefresh.listen((event){
    event.toString();
    print("Token is refresh");
  });
}



  Future initLocalNotifications(RemoteMessage message)async
  {
    var androidInitializationSettings=AndroidInitializationSettings('@mipmap/ic_launcher');///icon shown on notification
    var iosInitializationSettings=DarwinInitializationSettings();
    var initializationSetting=InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payLoad){

      }
    );

  }

  Future firebaseMessage()async
  {
    FirebaseMessaging.onMessage.listen((message) async {
    //  if(kDebugMode)
      {
        print(message.notification!.title);
        print(message.notification!.body);
      }
      if (Platform.isAndroid) {
        await initLocalNotifications(message);
        await showNotification(message);
      }
    });
  }

  Future showNotification(RemoteMessage message)async
  {
    AndroidNotificationChannel _channel=AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      "High Importance Notifications",
      importance: Importance.max  ///high rakhny sy notification Ui ma show na hun gy.
    );

    AndroidNotificationDetails androidNotificationDetails=AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: "your channel Description",
      importance: Importance.high,
      priority: Priority.high,
      ticker: "ticker"
    );

    DarwinNotificationDetails darwinNotificationDetails=DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails=NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails
    );

    await _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetails
    );
  }





  Future showLocalNotification({required String title, required String body}) async {
    var androidDetails = const AndroidNotificationDetails(
      'test_channel',
      'Test Channel',
      channelDescription: 'Channel for local testing',
      importance: Importance.high,
      priority: Priority.high,
    );

    var iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var generalNotificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,       // Notification ID (0 = overwrite, random if you want multiple)
      title,   // Title
      body,    // Body
      generalNotificationDetails,
    );
  }




}