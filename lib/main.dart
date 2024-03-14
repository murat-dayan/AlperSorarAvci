import 'package:alper_soraravci/firebase_options.dart';
import 'package:alper_soraravci/screens/sign_screen.dart';
import 'package:alper_soraravci/screens/start_screen.dart';
import 'package:alper_soraravci/utils/push_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import './screens/home_screen.dart';
import 'package:flutter/material.dart';

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("some notification received");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  PushNotifications.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  runApp(const MyApp());
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

bool isUserSigned() {
  return _firebaseAuth.currentUser != null;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isUserSigned() ? StartPage() : SignPage(),
    );
  }
}
