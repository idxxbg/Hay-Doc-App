import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hay_doc_app/api/api_services.dart';
import 'package:hay_doc_app/screen/book/quiz_screen.dart';
import 'package:hay_doc_app/screen/test_screen.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:hay_doc_app/screen/history_list/quiz.dart';

import 'package:hay_doc_app/style.dart';
import 'package:spring/spring.dart';

import 'book.dart';

class HayDoc extends StatefulWidget {
  const HayDoc({super.key});

  @override
  State<HayDoc> createState() => _HayDocState();
}

class _HayDocState extends State<HayDoc> {
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
                        "http://idxxbg.xp3.biz/API/haydoc/images/vldvcd.jpg",
                      ),
                      width: 500,
                      height: screenH * 0.3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "wellcome to our".toUpperCase(),
                style: const TextStyle(color: lightgrey, fontSize: 20),
              ),
              Text(
                "hay doc".toUpperCase(),
                style: const TextStyle(
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
                    Spring.bubbleButton(
                      animDuration: const Duration(seconds: 1),
                      bubbleStart: 0.8,
                      bubbleEnd: 1.0,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Book(),
                            ),
                          );
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 100,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(25)),
                        child: Text(
                          'sách'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: blue,
                          ),
                        ),
                      ),
                    ),
                    Spring.bubbleButton(
                      animDuration: const Duration(seconds: 1),
                      bubbleStart: 0.8,
                      bubbleEnd: 1.0,
                      onTap: () {
                        HapticFeedback.lightImpact();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 100,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(25)),
                        child: Text(
                          'reporter'.toUpperCase(),
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
