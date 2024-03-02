import 'package:alper_soraravci/constants/colors.dart';
import 'package:alper_soraravci/screens/start_screen.dart';
import 'package:alper_soraravci/widgets/main_button.dart';
import 'package:alper_soraravci/widgets/next_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class SignPage extends StatefulWidget {
  const SignPage({super.key});

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  
  _signInWithGoogle() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        await _firebaseAuth.signInWithCredential(credential);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => StartPage()));
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundAppColor,
      body: Container(
        color: crema,
        child: Column(
          children: [
            Lottie.asset('assets/animations/sign_anim.json',
                fit: BoxFit.contain, repeat: true),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("İstikbal Göklerdedir",
                    style: GoogleFonts.anton(
                        textStyle: TextStyle(fontSize: 25.0))),
                Text("-Mustafa Kemal Atatürk",
                    style: GoogleFonts.shadowsIntoLight(
                        textStyle: TextStyle(fontSize: 16.0))),
                Lottie.asset('assets/animations/arrow_bottom.json',
                fit: BoxFit.contain, repeat: true, width: 100, height: 200),        
              
                GestureDetector(
                  onTap: () {
                    _signInWithGoogle();
                  },
                  child: MainButton(
                      buttonName: "Google ile giriş yap",
                      iconName: FontAwesomeIcons.google,
                      iconColor: Colors.red),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
