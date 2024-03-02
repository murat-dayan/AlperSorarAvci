import 'package:alper_soraravci/constants/colors.dart';
import 'package:alper_soraravci/screens/home_screen.dart';
import 'package:alper_soraravci/screens/sign_screen.dart';
import 'package:alper_soraravci/widgets/main_button.dart';
import 'package:alper_soraravci/widgets/next_button.dart';
import 'package:alper_soraravci/widgets/speech_bubble.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  

  int welcomeTextIndex = 0;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String? userName;

  
  
  Future<String?> getCurrentUser() async{
    String? usermail = await _auth.currentUser?.email;  
    if(usermail != null){
      if(usermail.isNotEmpty){
        return usermail;
      }
    }
    return usermail;
  }

  
  @override
  void initState() {
    super.initState();
  //   getCurrentUser().then((usermail) {
  //   if (usermail != null) {
  //     userName = usermail;

  //     // Now you can use the userName variable after it's set
  //     print("Welcome, $userName!");
  //   } else {
  //     // Handle the case where no user is found
  //     print("No user found.");
  //   }
  // });
  }
  

  void _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignPage()));
  }

   List<String> welcomeTexts = [
    'Merhaba ',
    'Ben Alper Soraravcı ',
    'Gezeravcı değil evet',
    'Sana uzayla ilgili sorular soracağım',
    'Hazır mısın?',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundAppColor,
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Lottie.asset('assets/animations/welcome_animation.json',
                  fit: BoxFit.contain, width: 400, height: 400, repeat: true),
              if (welcomeTextIndex < welcomeTexts.length) ...[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      welcomeTextIndex++;
                    });
                  },
                  child:
                      SpeechBubble(bubbleText: welcomeTexts[welcomeTextIndex]),
                ),
              ],
              if (welcomeTextIndex >= welcomeTexts.length) ...[
                Column(
                  children: [
                    GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen())),
                        child: MainButton(
                          buttonName: "Çözmeye Başla",
                          iconName: FontAwesomeIcons.arrowRight,
                          iconColor: backgroundAppColor,
                        )),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        _signOut();
                      },
                      child: Text(
                        'Çıkış Yap',
                        style: TextStyle(
                            color: darkBlue,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                  ],
                )
              ],
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ));
  }
}
