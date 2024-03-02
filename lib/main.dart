

import 'package:alper_soraravci/firebase_options.dart';
import 'package:alper_soraravci/screens/sign_screen.dart';
import 'package:alper_soraravci/screens/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/home_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
    const MyApp()
  );
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

bool isUserSigned(){
  return _firebaseAuth.currentUser != null;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isUserSigned() ? StartPage() : SignPage() ,
    );
  }
}