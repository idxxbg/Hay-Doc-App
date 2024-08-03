import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass/glass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hay_doc_app/api/api_services.dart';
// import 'package:hay_doc_app/services/api_services.dart';
// import 'package:http/http.dart' as http;
import 'package:hay_doc_app/style.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    quiz = getQuizData();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    // startTimer().cancel();
    timer!.cancel();
  }

  late Future quiz;
  int seconds = 60;
  var currentIndexOfQuestion = 0;
  Timer? timer;
  bool isLoading = false;
  List<dynamic> optionList = [];

  String numberToAlphabet(int number) {
    // Chuyển đổi số thành chữ cái, số 0 tương ứng với 'A'
    return String.fromCharCode(65 + number);
  }

  resetColor() {
    optionColor = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
    ];
  }

// bắt đầu thời gian
  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          gotoNextQuestion();
        }
      });
    });
  }

  // dừng thời gian
  void stopTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
  }

  gotoNextQuestion() {
    isLoading = false;
    resetColor();
    currentIndexOfQuestion <= 20
        ? currentIndexOfQuestion++
        : currentIndexOfQuestion;
    timer!.cancel();
    seconds = 60;
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlue,
              blue,
              darkBlue,
            ],
          ),
        ),
        child: FutureBuilder(
          future: quiz,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              dynamic data = snapshot.data["results"];
              if (isLoading == false) {
                optionList = data[currentIndexOfQuestion]['incorrect_answers'];
                optionList.add(data[currentIndexOfQuestion]['correct_answer']);
                optionList
                    .shuffle(); // it makes the correct answer in differnt index
                isLoading = true;
              }
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                "$seconds",
                                style: GoogleFonts.pressStart2p(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator(
                                  value: seconds / 60,
                                  valueColor: const AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      // const SizedBox(height: 20),
                      Center(
                        child: Hero(
                          tag: "image",
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.asset(
                              "assets/images/execution thinking.webp",
                              width: 200,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Question ${currentIndexOfQuestion + 1} of ${data.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        data[currentIndexOfQuestion]['question'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      // question choice here
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: optionList.length,
                        itemBuilder: (BuildContext context, index) {
                          String alphabet = numberToAlphabet(index);
                          var correctAnswser =
                              data[currentIndexOfQuestion]['correct_answer'];
                          String answer = optionList[index].toString();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: optionColor[index].withOpacity(0.9),
                              ),
                              child: ListTile(
                                selectedColor: optionColor[index],
                                onTap: () {
                                  setState(
                                    () {
                                      stopTimer();

                                      HapticFeedback.lightImpact();
                                      if (correctAnswser.toString() == answer) {
                                        optionColor[index] = Colors.green;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                showCloseIcon: true,
                                                duration:
                                                    const Duration(seconds: 2),
                                                content: Text(
                                                    "$correctAnswser là câu trả lời đúng")));
                                        if (currentIndexOfQuestion <
                                            data.length - 1) {
                                          Future.delayed(
                                              const Duration(milliseconds: 200),
                                              () {
                                            gotoNextQuestion();
                                          });
                                        } else {
                                          timer!.cancel();
                                        }
                                      } else {
                                        optionColor[index] = Colors.red;

                                        showDialog(
                                            context: context,
                                            builder: (BuildContext content) {
                                              return AlertDialog(
                                                title: Text(
                                                    data[currentIndexOfQuestion]
                                                        ['correct_answer']),
                                                content: Text(
                                                  data[currentIndexOfQuestion]
                                                      ['question'],
                                                  style: TextStyle(),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      if (currentIndexOfQuestion <
                                                          data.length - 1) {
                                                        Navigator.pop(context);
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    200), () {
                                                          gotoNextQuestion();
                                                        });
                                                      } else {
                                                        timer!.cancel();
                                                      }
                                                    },
                                                    child: const Text("đóng"),
                                                  )
                                                ],
                                              );
                                            });
                                      }
                                    },
                                  );
                                },
                                leading: Text(
                                  "$alphabet.",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                                title: Text(
                                  optionList[index].toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ).asGlass(
                                clipBehaviour: Clip.hardEdge,
                                blurX: 0.1,
                                blurY: 0.1,
                                tintColor: optionColor[index],
                                clipBorderRadius: BorderRadius.circular(30)),
                          );
                        },
                      )
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
