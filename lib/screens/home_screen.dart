import 'dart:convert';
import 'package:alper_soraravci/widgets/option_card.dart';
import 'package:alper_soraravci/widgets/question_widget.dart';
import 'package:alper_soraravci/widgets/result_box.dart';
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

  Future<List<Question>> getAllQuestions() async {
    final databaseReference = FirebaseDatabase.instance.ref();

    // Verileri çek
    final snapshot = await databaseReference.child('questions').once();
    final values = snapshot.snapshot.value as Map<Object?, Object?>;

    List<Question> newQuestions = [];
    try {
      Map<String?, dynamic> data = values.cast<String?, dynamic>();

      data.forEach((key, value) {
        var newQuestion = Question(
            id: key!!,
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
    _questions = getAllQuestions();
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
        score = score +10;
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
                iconTheme: IconThemeData(
                  color: neutral
                ),
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
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                        onTap: () => checkAnswerAndUpdate(
                            extractedData[index].options.values.toList()[i]),
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
