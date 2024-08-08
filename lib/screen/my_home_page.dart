import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hay_doc_app/api/api_services.dart';
import 'package:hay_doc_app/screen/test_screen.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:hay_doc_app/screen/history_list/quiz.dart';

import 'package:hay_doc_app/style.dart';

import 'book/quiz_screen.dart';
import 'quiz_screen2.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    bookdata = getQuizData();
    historydata = getQuizData2();
  }

  late Future historydata;
  late Future bookdata;

  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    double screenw = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (_) => const TestScreen()));
        },
        child: const Icon(CupertinoIcons.sparkles),
      ),
      body: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Hero(
                  tag: "image",
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child:
                        // Image.asset("assets/images/Logo Tu duy thuc thi.jpg")
                        ProgressiveImage(
                      placeholder:
                          const AssetImage("assets/images/placeholder.jpg"),
                      thumbnail:
                          const AssetImage("assets/images/placeholder.jpg"),
                      image: const NetworkImage(
                        "http://idxxbg.xp3.biz/API/haydoc/images/tuduythucthi.jpg",
                      ),
                      width: 500,
                      height: screenH * 0.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "wellcome to our",
                style: TextStyle(color: lightgrey, fontSize: 20),
              ),
              const Text(
                "QUY LUẬT THÀNH CÔNG",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Center(
                child: ListView(
                  shrinkWrap: true,
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 100,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
                        child: Text(
                          'The Book'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: blue,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Quiz(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 100,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
                        child: Text(
                          'Lịch sử lớp 6'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
