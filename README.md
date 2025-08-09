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


