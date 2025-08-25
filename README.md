# firebase_practice

First,
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

And add these in "main" function.

WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform,
);

IN Phone Authentication:
Go to the project folder in the terminal.

Mac command:  keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
Windows command:  keytool -list -v -keystore "C:\Users\bilal\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
Linux keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

**_Push_Notification_**
android/app/build.gradle ma  applicationId = "com.umartech.firebase_practice"  iss ma example change karna.
# in android/app/build.gradle ma make these changes:     Error Fixed of local_notification....
in compileOption{
 //old code
//add below
isCoreLibraryDesugaringEnabled = true
}
and at end of this file add this:
dependencies {
// ✅ Kotlin DSL uses function style
coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
# ---------------------------------------------------------------------------------- #

--->First get notification permission.
--->get FCM/Device token then print it on console copy and paste in firebase console messaging
# Add below in android/aoo/src/main/AndroidManifest.xml
<meta-data
android:name="com.google.firebase.messaging.default_notification_channel_id"
android:value="high_importance_channel" />
