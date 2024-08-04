import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';

import 'package:hay_doc_app/style.dart';

import 'quiz_screen.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ])),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProgressiveImage(
                placeholder: AssetImage("assets/images/placeholder.jpg"),
                thumbnail: AssetImage("assets/images/placeholder.jpg"),
                image: NetworkImage(
                    "http://idxxbg.xp3.biz/API/haydoc/images/execution%20thinking.webp"),
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              Hero(
                tag: "image",
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset("assets/images/execution thinking.webp"),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "wellcome to our",
                style: TextStyle(color: lightgrey, fontSize: 18),
              ),
              const Text(
                "Quiz App",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const QuizScreen()));
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
                      'continue'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: blue,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
