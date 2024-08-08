import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass/glass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hay_doc_app/api/api_services.dart';
import 'package:hay_doc_app/screen/result_screen.dart';
import 'package:hay_doc_app/style.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    super.initState();
    quiz = getQuizData3();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  late Future quiz;
  int seconds = 60;
  var currentIndexOfQuestion = 0;
  Timer? timer;
  bool isLoading = false;
  List<dynamic> optionList = [];
  List<dynamic> listcorrectAnswer = [];
  List<dynamic> listincorrectAnswer = [];

  String numberToAlphabet(int number) {
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

  void stopTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
  }

  gotoNextQuestion() {
    setState(() {
      isLoading = false;
      resetColor();
      currentIndexOfQuestion < 60 ? currentIndexOfQuestion++ : null;
      timer!.cancel();
      seconds = 60;
      startTimer();
    });
  }

  endgame(dynamic data) {
    if (currentIndexOfQuestion < data.length - 1) {
      Future.delayed(const Duration(milliseconds: 200), () {
        gotoNextQuestion();
      });
    } else {
      timer!.cancel();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            listcorrectAnswser: listcorrectAnswer,
            listincorrectAnswser: listincorrectAnswer,
            totalQuestion: currentIndexOfQuestion + 1,
          ),
        ),
      );
    }
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
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

                // Phần FutureBuilder xử lý dữ liệu
                FutureBuilder(
                  future: quiz,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      // Lọc các câu hỏi của chương 1, bài 1, phần 1
                      List<dynamic> filteredData = snapshot.data["results"]
                          .where((question) =>
                              question["chapter"] == "CHƯƠNG 1" &&
                              question["lesson"] == "BÀI 1: LỊCH SỬ LÀ GÌ?" &&
                              question["section"] == "VÌ SAO PHẢI HỌC LỊCH SỬ?")
                          .toList();

                      dynamic data = filteredData;

                      if (isLoading == false) {
                        optionList =
                            data[currentIndexOfQuestion]['incorrect_answers'];
                        optionList.add(
                            data[currentIndexOfQuestion]['correct_answer']);
                        optionList.shuffle();
                        isLoading = true;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          const SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Question ${currentIndexOfQuestion + 1} of ${data.length}",
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 18,
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
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: optionList.length,
                            itemBuilder: (BuildContext context, index) {
                              String alphabet = numberToAlphabet(index);
                              var correctAnswser = data[currentIndexOfQuestion]
                                  ['correct_answer'];
                              var id =
                                  data[currentIndexOfQuestion]['id'].toString();
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
                                      setState(() {
                                        stopTimer();
                                        if (correctAnswser.toString() ==
                                            answer) {
                                          optionColor[index] = Colors.green;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            showCloseIcon: true,
                                            duration:
                                                const Duration(seconds: 2),
                                            content: Text(
                                                "$correctAnswser là câu trả lời đúng"),
                                          ));
                                          listcorrectAnswer.add(id);
                                          HapticFeedback.lightImpact();

                                          endgame(data);
                                        } else {
                                          optionColor[index] = Colors.red;
                                          listincorrectAnswer.add(id);
                                          HapticFeedback.heavyImpact();

                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext content) {
                                              return AlertDialog(
                                                actionsAlignment:
                                                    MainAxisAlignment.center,
                                                alignment:
                                                    Alignment.bottomCenter,
                                                content: Container(
                                                  height: 100,
                                                  child: Center(
                                                    child: Text(
                                                      data[currentIndexOfQuestion]
                                                          ['correct_answer'],
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .green.shade700,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  ElevatedButton(
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
                                                    child: const Icon(
                                                        Icons.cancel_outlined),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      });
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
                                  clipBorderRadius: BorderRadius.circular(30),
                                ),
                              );
                            },
                          ),
                        ],
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

                // Add more widgets if needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
