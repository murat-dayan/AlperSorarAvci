import '../constants/colors.dart';
import 'package:flutter/material.dart';

class ResultBox extends StatelessWidget {
  const ResultBox(
      {super.key, required this.result, required this.questionLength, required this.startOverPress});

  final int result;
  final int questionLength;
  final VoidCallback startOverPress;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundAppColor,
      content: Padding(
        padding: EdgeInsets.all(60.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sonuç',
              style: TextStyle(color: neutral, fontSize: 20.0),
            ),
            const SizedBox(
              height: 20.0,
            ),
            CircleAvatar(
                child: Text(
                  '$result/${questionLength*10}',
                  style: TextStyle(fontSize: 30.0, color: neutral),
                ),
                radius: 60.0,
                backgroundColor: result == (questionLength*10) / 2
                    ? Colors.yellow
                    : result < (questionLength*10) / 2
                        ? inCorrect
                        : correct
            ),
            SizedBox(height: 20.0,),
            Text(
              result == (questionLength*10) / 2
                    ? 'eh idare eder'
                    : result < (questionLength*10) / 2
                        ? 'üzgünüm dostum sınıfta kaldın'
                        : '55 milyon dolarını al gel',
              style: TextStyle(
                color: neutral
              ),          

            ),
            const SizedBox(height: 25.0,),
            GestureDetector(
              onTap: startOverPress,
              child: Text(
                'Yeniden Başla',
                style: TextStyle(
                  color: crema,
                  fontSize: 20.0,
                  letterSpacing: 1.0,
                  decoration: TextDecoration.underline
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
