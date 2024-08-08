import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hay_doc_app/style.dart';
import 'package:spring/spring.dart';

class Book extends StatelessWidget {
  const Book({super.key});

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
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                ],
              ),

              const SizedBox(height: 20),
              //học tập
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "học tập".toUpperCase(),
                  style: GoogleFonts.nunito(
                    fontSize: 30,
                    color: Colors.black87,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              InkWell(
                splashFactory: InkSparkle.splashFactory,
                onTap: () {
                  HapticFeedback.lightImpact();
                },
                child: Spring.fadeIn(
                  // startOpacity: 0.6,
                  // endOpacity: 1,
                  // // animDuration: Duration(seconds: 1), //def=1s
                  // animStatus: (AnimStatus status) {
                  //   print(status);
                  // },
                  // curve: Curves.linear, //def=Curves.easInOut
                  // delay: const Duration(milliseconds: 500), //def=0

                  child: const Card(
                    elevation: 10,
                    color: Colors.white70,
                    child: ListTile(
                      leading: Icon(Icons.history_edu_rounded),
                      title: Text(
                        "Lịch sử",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                        ),
                      ),
                      trailing: Icon(CupertinoIcons.arrow_right_circle_fill),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                },
                child: Spring.fadeIn(
                  // startOpacity: 0.7,
                  // endOpacity: 1,
                  // // animDuration: Duration(seconds: 1), //def=1s
                  // animStatus: (AnimStatus status) {
                  //   print(status);
                  // },
                  // curve: Curves.easeInBack, //def=Curves.easInOut
                  // delay: const Duration(milliseconds: 500), //def=0
                  child: const Card(
                    elevation: 10,
                    color: Colors.white70,
                    child: ListTile(
                      leading: const Icon(Icons.language_rounded),
                      title: Text(
                        "Địa lý",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_circle_right_sharp),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              //kỹ năng
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "kỹ năng".toUpperCase(),
                  style: GoogleFonts.nunito(
                    fontSize: 30,
                    color: Colors.black87,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              InkWell(
                splashFactory: InkSparkle.splashFactory,
                onTap: () {
                  HapticFeedback.lightImpact();
                },
                child: Spring.fadeIn(
                  child: const Card(
                    shadowColor: Colors.transparent,
                    elevation: 10,
                    color: Colors.white70,
                    child: ListTile(
                      leading: Icon(Icons.auto_graph_sharp),
                      title: Text(
                        "Quy luật thành công",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                        ),
                      ),
                      trailing: Icon(CupertinoIcons.arrow_right_circle_fill),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  HapticFeedback.heavyImpact();
                },
                child: Spring.opacity(
                  startOpacity: 0.1,
                  endOpacity: 1,
                  // onTap: () {
                  //   HapticFeedback.lightImpact();
                  // },
                  child: const Card(
                    shadowColor: Colors.transparent,
                    elevation: 10,
                    color: Colors.white70,
                    child: ListTile(
                      leading: Icon(Icons.auto_graph_sharp),
                      title: Text(
                        "Quy luật thành công",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                        ),
                      ),
                      trailing: Icon(CupertinoIcons.arrow_right_circle_fill),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
