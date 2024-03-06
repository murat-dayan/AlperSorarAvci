import 'package:alper_soraravci/constants/colors.dart';
import 'package:flutter/material.dart';

class LeaderBoardTile extends StatelessWidget {
  final String name;
  final int score;
  final int index;

  const LeaderBoardTile(
      {Key? key, required this.name, required this.score, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backgroundAppColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            "$index - $name",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: neutral),
          ),
          Spacer(),
          Text(
            '$score',
            style: TextStyle(
                color: neutral, fontSize: 16, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
