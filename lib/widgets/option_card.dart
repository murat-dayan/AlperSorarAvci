import 'package:alper_soraravci/constants/colors.dart';
import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  const OptionCard({super.key, required this.option, required this.color,});

  final String option;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Container(
        child: ListTile(
          title: Text(
            option,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color:color.red != color.green ? neutral :Colors.black // color kırmızı veya yeşil ise beyaz, değilse siyah text
            ),
          ),
        ),
      ),
      
    );
  }
}