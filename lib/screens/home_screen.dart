import 'dart:convert';
import 'dart:math';
import 'package:alper_soraravci/widgets/option_card.dart';
import 'package:alper_soraravci/widgets/question_widget.dart';
import 'package:alper_soraravci/widgets/result_box.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/next_button.dart';
import '../models/question_model.dart';
import '../constants/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final audioPlayer = AudioPlayer();

  void saveScore(int score) async {
    final user = _auth.currentUser;

    final docRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    int currentScore = (await docRef.get()).data()!['score'];

    if (score > currentScore) {
      await docRef.set({'score': score}, SetOptions(merge: true));
    }
  }

  Future<void> addQuestion(Question question) async {
    final databaseReference = FirebaseDatabase.instance.ref();

    // Question modelinin her özelliğini ayrı ayrı ekle
    final questionData = {
      'title': question.title,
      'options': question.options,
    };

    // Veriyi ekle
    await databaseReference.child('questions').push().set(questionData);
  }

  Future<List<Question>> getRandomQuestions() async {
    final databaseReference = FirebaseDatabase.instance.ref();

    final query = databaseReference.child('questions');

    // Verileri çek
    final snapshot = await query.once();
    final values = snapshot.snapshot.value as Map<Object?, Object?>;

    List<Question> newQuestions = [];
    try {
      Map<String?, dynamic> data = values.cast<String?, dynamic>();

      // Alınan verilerin uzunluğu
      int dataLength = data.length;

      // Rasgele indisler için bir liste oluştur
      List<int> randomIndices = [];

      // Veri uzunluğu kadar rasgele indisler oluştur
      while (randomIndices.length < min(dataLength, 10)) {
        int randomIndex = Random().nextInt(dataLength);
        if (!randomIndices.contains(randomIndex)) {
          randomIndices.add(randomIndex);
        }
      }

      // Rasgele indislerle veri seç
      randomIndices.forEach((index) {
        var key = data.keys.elementAt(index);
        var value = data[key];

        var newQuestion = Question(
            id: key!,
            title: value['title'],
            options: Map.castFrom(value['options']));

        newQuestions.add(newQuestion);
      });
    } catch (e) {
      print("Hata: $e");
      // Hata durumunda yapılacak işlemler
    }
    return newQuestions;
  }

  late Future _questions;

  @override
  void initState() {
    super.initState();
    _questions = getRandomQuestions();
  }

  int index = 0;
  bool isPressed = false;
  int score = 0;
  bool isAlreadySelected = false;

  void nextQuestion(int questionLength) async {
    if (index == questionLength - 1) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => ResultBox(
                result: score,
                questionLength: questionLength,
                startOverPress: startOver,
              ));
      saveScore(score);
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Lütfen bir şık seçiniz!'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 20.0),
        ));
      }
    }
  }

  void checkAnswerAndUpdate(bool value) {
    if (isAlreadySelected) {
      return;
    } else {
      if (value) {
        score = score + 10;
      }
      setState(() {
        isPressed = true;
        isAlreadySelected = true;
      });
    }
  }

  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
    });
    Navigator.pop(context);
  }

  Future<void> playCorrectChoiceSound() async {
    String audioPath = "sounds/correct_choice.mp3";
    await audioPlayer.play(AssetSource(audioPath));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _questions as Future<List<Question>>,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            var extractedData = snapshot.data as List<Question>;
            return Scaffold(
              backgroundColor: backgroundAppColor,
              appBar: AppBar(
                backgroundColor: backgroundAppColor,
                toolbarHeight: 60.0,
                iconTheme: IconThemeData(color: neutral),
                shadowColor: Colors.transparent,
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      '$score',
                      style: TextStyle(fontSize: 25.0, color: neutral),
                    ),
                  )
                ],
              ),
              body: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 50.0),
                child: Column(
                  children: [
                    QuestionWidget(
                        question: extractedData[index].title,
                        indexAction: index,
                        totalQuestions: extractedData.length),
                    const Divider(
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    for (int i = 0;
                        i < extractedData[index].options.length;
                        i++)
                      GestureDetector(
                        onTap: () => {
                          checkAnswerAndUpdate(
                              extractedData[index].options.values.toList()[i]),
                          if (isPressed &&
                              extractedData[index].options.values.toList()[i] ==
                                  true)
                            {playCorrectChoiceSound()}
                        },
                        child: OptionCard(
                            option:
                                extractedData[index].options.keys.toList()[i],
                            color: isPressed
                                ? extractedData[index]
                                            .options
                                            .values
                                            .toList()[i] ==
                                        true
                                    ? correct
                                    : inCorrect
                                : neutral),
                      )
                  ],
                ),
              ),
              floatingActionButton: GestureDetector(
                onTap: () => nextQuestion(extractedData.length),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: NextButton(buttonName: "Sıradaki Soru"),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return const Center(
          child: Text("No Data"),
        );
      },
    );
  }
}
