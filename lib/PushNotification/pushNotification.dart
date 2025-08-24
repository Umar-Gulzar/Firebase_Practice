import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:app_settings/app_settings.dart';

class NotificationServices
{
  FirebaseMessaging messaging=FirebaseMessaging.instance;

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

}