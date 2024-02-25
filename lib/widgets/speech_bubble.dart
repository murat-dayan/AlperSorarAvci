import 'package:alper_soraravci/constants/colors.dart';
import 'package:flutter/material.dart';

class SpeechBubble extends StatelessWidget {
  const SpeechBubble({super.key, required this.bubbleText});

  final String bubbleText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: neutral,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(100.0)), // Köşeleri yuvarlatın
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(bubbleText, 
          style: TextStyle(
            fontSize: 14.0
          ),),
          Icon(Icons.arrow_right,)
        ],
      )
    );
  }
}
