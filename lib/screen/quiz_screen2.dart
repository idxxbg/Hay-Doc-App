import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass/glass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hay_doc_app/api/api_services.dart';
import 'package:hay_doc_app/screen/result_screen.dart';
// import 'package:hay_doc_app/services/api_services.dart';
// import 'package:http/http.dart' as http;
import 'package:hay_doc_app/style.dart';

class QuizScreen2 extends StatefulWidget {
  const QuizScreen2({super.key});

  @override
  State<QuizScreen2> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen2> {
  @override
  void initState() {
    super.initState();
    quiz = getQuizData2();
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
  List<dynamic> listcorrectAnswer = [];
  List<dynamic> listincorrectAnswer = [];

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

  //chuyen sang cau tiep theo
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

  // ket thuc game
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
                              "assets/images/20240804-203216.jpg",
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
                                        listcorrectAnswer.add(id);

                                        endgame(data);
                                      } else {
                                        optionColor[index] = Colors.red;
                                        listincorrectAnswer.add(id);

                                        print(listincorrectAnswer);

                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext content) {
                                              return AlertDialog(
                                                actionsAlignment:
                                                    MainAxisAlignment.center,
                                                alignment:
                                                    Alignment.bottomCenter,
                                                // title: Text(
                                                //   data[currentIndexOfQuestion]
                                                //       ['correct_answer'],
                                                //   style: TextStyle(
                                                //       fontSize: 20,
                                                //       fontWeight:
                                                //           FontWeight.bold,
                                                //       color: Colors
                                                //           .green.shade700),
                                                // ),
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
                                                              .green.shade700),
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
                                                  // TextButton(
                                                  //   onPressed: () {
                                                  //     if (currentIndexOfQuestion <
                                                  //         data.length - 1) {
                                                  //       Navigator.pop(context);
                                                  //       Future.delayed(
                                                  //           const Duration(
                                                  //               milliseconds:
                                                  //                   200), () {
                                                  //         gotoNextQuestion();
                                                  //       });
                                                  //     } else {
                                                  //       timer!.cancel();
                                                  //     }
                                                  //   },
                                                  //   child:
                                                  // )
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
