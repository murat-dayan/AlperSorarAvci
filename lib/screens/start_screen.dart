import 'package:alper_soraravci/constants/colors.dart';
import 'package:alper_soraravci/screens/home_screen.dart';
import 'package:alper_soraravci/screens/leader_board_screen.dart';
import 'package:alper_soraravci/screens/sign_screen.dart';
import 'package:alper_soraravci/widgets/main_button.dart';
import 'package:alper_soraravci/widgets/speech_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int welcomeTextIndex = 0;
  bool hasLoadedUsers = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  String userName = "";

  void loadUsers() async {
    final user = await _auth.currentUser;

    if (user != null) {
      try {
        final docRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final snapshot = await docRef.get();

        if (snapshot.exists) {
          final data = snapshot.data();
          setState(() {
            userName = data!['username'];
            hasLoadedUsers = true;
          });
        } else {
          setState(() {
            hasLoadedUsers = true;
          });
          showUserNameDialog();
        }
      } catch (e) {
        print("hata $e");
      }
    }
  }

  void showUserNameDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Kullanıcı adınızı giriniz"),
            content: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                onChanged: (value) {
                  userName = value;
                },
              ),
            ),
            actions: <Widget>[
              FloatingActionButton(
                onPressed: () async {
                  final user = _auth.currentUser;
                  final docRef = FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid);
                  await docRef.set({
                    'username': userName,
                    'email': user.email,
                    'uid': user.uid,
                    'score': 0
                  });
                  Navigator.of(context).pop();
                },
                child: Text("Kaydet"),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void _signOut() async {
    await googleSignIn.disconnect();
    await _auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignPage()));
  }

  List<String> welcomeTexts = [
    'Merhaba  ',
    'Ben Alper Soraravcı ',
    'Gezeravcı değil evet',
    'Sana uzayla ilgili sorular soracağım',
    'Hazır mısın?',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundAppColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Alper SorarAvcı",
            style: TextStyle(color: neutral),
          ),
          centerTitle: true,
          backgroundColor: backgroundAppColor,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LeaderBoardPage()));
              },
              icon: Icon(FontAwesomeIcons.rankingStar),
              color: neutral,
            )
          ],
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (hasLoadedUsers) ...[
                Lottie.asset('assets/animations/welcome_animation.json',
                    fit: BoxFit.contain, width: 400, height: 400, repeat: true),
                if (welcomeTextIndex < welcomeTexts.length) ...[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        welcomeTextIndex++;
                      });
                    },
                    child: SpeechBubble(
                        bubbleText: welcomeTexts[welcomeTextIndex]),
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
                            buttonName: "Haydi $userName",
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
            ],
          ),
        ));
  }
}
