import '../constants/colors.dart';
import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key, required this.buttonName});
  
  final String buttonName;

  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: neutral,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child:Text(
        buttonName,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.0
        ),
      ),
    );
  }
}