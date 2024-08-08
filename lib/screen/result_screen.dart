import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hay_doc_app/screen/my_home_page.dart';
import 'package:hay_doc_app/style.dart';

class ResultScreen extends StatelessWidget {
  // var listincorrectAnswer;

  const ResultScreen({
    super.key,
    required this.listcorrectAnswser,
    required this.listincorrectAnswser,
    required this.totalQuestion,
  });

  final List<dynamic> listcorrectAnswser;
  final List<dynamic> listincorrectAnswser;
  final int totalQuestion;

  @override
  Widget build(BuildContext context) {
    int listincorr = listincorrectAnswser.length;
    int listcorr = listcorrectAnswser.length;
    double percent = (listcorr / totalQuestion) * 100;
    String per = percent.toStringAsFixed(2);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        // backgroundColor: Colors.white38,
        icon: Icon(
          Icons.home,
          color: Colors.grey.shade500,
        ),
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const MyHomePage()));
        },
        label: const Text(
          "Go Home",
          style: TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
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
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                      // color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(25)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // const SizedBox(height: 30),
                      Text(
                        "Your Score",
                        style: GoogleFonts.pressStart2p(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),

                      // const SizedBox(height: 40),
                      percent >= 50
                          ? Card(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '$per%',
                                  style: const TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w900,
                                    color: Color.fromARGB(207, 76, 175, 79),
                                  ),
                                ),
                              ).asGlass(
                                  tintColor: Colors.white,
                                  clipBorderRadius: BorderRadius.circular(10)),
                            )
                          : Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '$per%',
                                  style: const TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w900,
                                    color: Color.fromARGB(202, 255, 82, 82),
                                  ),
                                ),
                              ),
                            ),
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.051,
                      // ),

                      percent > 50
                          ? Column(
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: Text(
                                      "số câu đúng : $listcorr".toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: Text(
                                      "số câu sai : $listincorr".toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: Text(
                                      "số câu sai : $listincorr".toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: Text(
                                      "số câu đúng : $listcorr".toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ).asGlass(
                    clipBorderRadius: BorderRadius.circular(25),
                    tintColor: Colors.white70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
