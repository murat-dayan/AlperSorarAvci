import 'package:alper_soraravci/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainButton extends StatelessWidget {
  const MainButton({super.key, required this.buttonName, required this.iconName, required this.iconColor});

  final String buttonName;
  final IconData iconName;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.0),
        margin: EdgeInsets.symmetric(horizontal: 30.0),
        decoration: BoxDecoration(
            color: darkBlue, 
            borderRadius: BorderRadius.circular(20.0)
          ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              buttonName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: crema
                ),
            ),
            SizedBox(width: 10.0,),
            Icon(
              iconName,
              size: 20.0,
              color: iconColor,
            )
          ],
        ));
  }
}
