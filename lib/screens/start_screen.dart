import 'package:alper_soraravci/constants/colors.dart';
import 'package:alper_soraravci/screens/home_screen.dart';
import 'package:alper_soraravci/widgets/next_button.dart';
import 'package:alper_soraravci/widgets/speech_bubble.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List<String> welcomeTexts = [
    'Merhaba ben Alper Soraravcı',
    'Gezeravcı değil evet ehe',
    'Sana uzayla ilgili sorular soracağım',
    'Hazır mısın?',
  ];

  int welcomeTextIndex = 0;

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
                GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen())),
                    child: NextButton(buttonName: "Başlayalım")),
              ],
              SizedBox(
                height: 10.0,
              )
            ],
          ),
        ));
  }
}
