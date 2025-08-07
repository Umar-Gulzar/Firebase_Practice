# firebase_practice

First,
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

And add these in "main" function.

WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform,
);
