import 'package:alper_soraravci/constants/colors.dart';
import 'package:alper_soraravci/widgets/leaderboard_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaderBoardPage extends StatelessWidget {
  const LeaderBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LeaderBoard",
          style: TextStyle(color: neutral),
        ),
        backgroundColor: backgroundAppColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('score', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final userDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: userDocs.length,
            itemBuilder: (context, index) {
              final userDoc = userDocs[index];
              final userName = userDoc['username'];
              final userScore = userDoc['score'];

              return LeaderBoardTile(
                name: userName,
                score: userScore,
                index: index + 1,
              );
            },
          );
        },
      ),
    );
  }
}
