import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:glass/glass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hay_doc_app/api/api_services.dart';
import 'package:hay_doc_app/screen/result_screen.dart';
import 'package:hay_doc_app/style.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
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
  bool hasAnswered = false;

  List<dynamic> chapters = [];
  List<dynamic> lessons = [];
  List<dynamic> sections = [];

  List<dynamic> optionList = [];
  List<dynamic> listcorrectAnswer = [];
  List<dynamic> listincorrectAnswer = [];

  String selectedChapter = '';
  String selectedLesson = '';
  String selectedSection = '';

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
      hasAnswered = false;
    });
  }

  String? getNextSection(List<dynamic> data) {
    int currentSectionIndex = sections.indexOf(selectedSection);
    if (currentSectionIndex != -1 &&
        currentSectionIndex < sections.length - 1) {
      return sections[currentSectionIndex + 1];
    }
    return null;
  }

  String? getNextLesson(List<dynamic> data) {
    int currentLessonIndex = lessons.indexOf(selectedLesson);
    if (currentLessonIndex != -1 && currentLessonIndex < lessons.length - 1) {
      return lessons[currentLessonIndex + 1];
    }
    return null;
  }

  String? getNextChapter(List<dynamic> data) {
    int currentChapterIndex = chapters.indexOf(selectedChapter);
    if (currentChapterIndex != -1 &&
        currentChapterIndex < chapters.length - 1) {
      return chapters[currentChapterIndex + 1];
    }
    return null;
  }

  void endgame(dynamic data) {
    if (currentIndexOfQuestion < data.length - 1) {
      Future.delayed(
        const Duration(milliseconds: 1000),
        () {
          gotoNextQuestion();
        },
      );
    } else {
      String? nextSection = getNextSection(data);
      String? nextLesson = nextSection == null ? getNextLesson(data) : null;
      String? nextChapter = nextLesson == null ? getNextChapter(data) : null;

      if (nextSection != null || nextLesson != null || nextChapter != null) {
        String nextContentType = nextSection != null
            ? 'phần'
            : nextLesson != null
                ? 'bài'
                : 'chương';

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Chuyển sang $nextContentType tiếp theo?'),
            content: Text(
                'Bạn có muốn tiếp tục sang $nextContentType tiếp theo không?'),
            actions: [
              TextButton(
                onPressed: () {
                  print(
                      "\n list incorrect : ${listincorrectAnswer.length} \n list correct : ${listcorrectAnswer.length} \n total : ${currentIndexOfQuestion + 1} \n  ");
                  // gotoNextQuestion();
                  stopTimer();
                  resetColor();
                  hasAnswered = false;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultScreen(
                        listcorrectAnswser: listcorrectAnswer,
                        listincorrectAnswser: listincorrectAnswer,
                        totalQuestion: currentIndexOfQuestion + 1,
                      ),
                    ),
                  );
                },
                child: const Text('Không'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  if (nextSection != null) {
                    moveToNextSection(nextSection);
                  } else if (nextLesson != null) {
                    moveToNextLesson(nextLesson);
                  } else if (nextChapter != null) {
                    moveToNextChapter(nextChapter);
                  }
                  hasAnswered = false;
                  resetDropdownState();
                },
                child: const Text('Có'),
              ),
            ],
          ),
        );
      } else {
        // Nếu không còn nội dung, kết thúc bài kiểm tra
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
  }

  void moveToNextSection(String nextSection) {
    setState(() {
      selectedSection = nextSection;
      resetDropdownState();
    });
  }

  void moveToNextLesson(String nextLesson) {
    setState(() {
      selectedLesson = nextLesson;
      selectedSection = ''; // Reset section
      resetDropdownState();
    });
  }

  void moveToNextChapter(String nextChapter) {
    setState(() {
      selectedChapter = nextChapter;
      selectedLesson = ''; // Reset lesson
      selectedSection = ''; // Reset section
      resetDropdownState();
    });
  }

  // Hàm để trích xuất danh sách chapter, lesson và section từ dữ liệu JSON
  void extractData(dynamic data) {
    chapters = data.map((item) => item['chapter']).toSet().toList();
    if (selectedChapter.isEmpty && chapters.isNotEmpty) {
      selectedChapter = chapters.first;
    }
    lessons = data
        .where((item) => item['chapter'] == selectedChapter)
        .map((item) => item['lesson'])
        .toSet()
        .toList();
    if (selectedLesson.isEmpty && lessons.isNotEmpty) {
      selectedLesson = lessons.first;
    }
    sections = data
        .where((item) =>
            item['chapter'] == selectedChapter &&
            item['lesson'] == selectedLesson)
        .map((item) => item['section'])
        .toSet()
        .toList();
    if (selectedSection.isEmpty && sections.isNotEmpty) {
      selectedSection = sections.first;
    }
  }

  // Hàm để lọc câu hỏi dựa trên chapter, lesson và section
  List<dynamic> filterQuestions(dynamic data) {
    return data
        .where((question) =>
            question["chapter"] == selectedChapter &&
            question["lesson"] == selectedLesson &&
            question["section"] == selectedSection)
        .toList();
  }

  // Hàm để đặt lại trạng thái khi thay đổi lựa chọn trong Dropdown
  void resetDropdownState() {
    setState(() {
      isLoading = false;
      currentIndexOfQuestion = 0;
      optionList = [];
      resetColor();
      timer!.cancel();
      seconds = 60;
      startTimer();
    });
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
                FutureBuilder(
                  future: quiz,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      dynamic data = snapshot.data["results"];

                      // Trích xuất chapter, lesson, section từ dữ liệu
                      extractData(data);

                      // Lọc câu hỏi dựa trên chapter, lesson và section đã chọn
                      List<dynamic> filteredData = filterQuestions(data);

                      if (filteredData.isNotEmpty) {
                        if (!isLoading) {
                          List<String> answers = [];

                          // Thêm câu trả lời đúng
                          answers.add(filteredData[currentIndexOfQuestion]
                              ['correct_answer']);

                          // Thêm các câu trả lời sai
                          answers.addAll(List<String>.from(
                              filteredData[currentIndexOfQuestion]
                                  ['incorrect_answers']));

                          // Trộn ngẫu nhiên các câu trả lời
                          answers.shuffle();

                          // Gán danh sách câu trả lời vào optionList
                          optionList = answers;

                          isLoading = true;
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Dropdown chọn Chapter
                            DropdownButton<String>(
                              icon: const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.arrow_drop_down_circle_outlined,
                                  color: Colors.white70,
                                ),
                              ),
                              underline: Text(""),
                              borderRadius: BorderRadius.circular(25),
                              dropdownColor: Colors.grey.shade600,
                              value: selectedChapter,
                              isExpanded: true,
                              items: chapters.map<DropdownMenuItem<String>>(
                                  (dynamic value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 7.0),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: FittedBox(
                                        child: Text(
                                          value,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedChapter = newValue!;
                                  selectedLesson = '';
                                  selectedSection = '';
                                  resetDropdownState(); // Đặt lại trạng thái
                                });
                              },
                            ).asGlass(
                              clipBorderRadius: BorderRadius.circular(25),
                            ),
                            const SizedBox(height: 5),
                            // Dropdown chọn Lesson
                            DropdownButton<String>(
                              icon: const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.arrow_drop_down_circle_outlined,
                                  color: Colors.white70,
                                ),
                              ),
                              underline: Text(""),
                              style: TextStyle(),
                              elevation: 1,
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(25),
                              dropdownColor: Colors.grey.shade600,
                              value: selectedLesson,
                              items: lessons.map<DropdownMenuItem<String>>(
                                  (dynamic value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: FittedBox(
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedLesson = newValue!;
                                  selectedSection = '';
                                  resetDropdownState(); // Đặt lại trạng thái
                                });
                              },
                            ).asGlass(
                              clipBorderRadius: BorderRadius.circular(25),
                            ),
                            const SizedBox(height: 5),

                            // Dropdown chọn Section
                            DropdownButton<String>(
                              icon: const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.arrow_drop_down_circle_outlined,
                                  color: Colors.white70,
                                ),
                              ),
                              // menuMaxHeight: 1000,
                              underline: Text(""),
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(25),
                              dropdownColor: Colors.black.withOpacity(0.8),
                              value: selectedSection,
                              items: sections.map<DropdownMenuItem<String>>(
                                  (dynamic value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: FittedBox(
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedSection = newValue!;
                                  resetDropdownState(); // Đặt lại trạng thái
                                });
                              },
                            ).asGlass(
                              clipBorderRadius: BorderRadius.circular(25),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Question ${currentIndexOfQuestion + 1} of ${filteredData.length}",
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
                              filteredData[currentIndexOfQuestion]['question'],
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
                                var correctAnswser =
                                    filteredData[currentIndexOfQuestion]
                                        ['correct_answer'];
                                var id = filteredData[currentIndexOfQuestion]
                                        ['id']
                                    .toString();
                                String answer = optionList[index].toString();

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color:
                                          optionColor[index].withOpacity(0.9),
                                    ),
                                    child: ListTile(
                                      selectedColor: optionColor[index],
                                      onTap: () {
                                        // Kiểm tra nếu người dùng đã chọn câu trả lời thì không cho phép chọn lại
                                        if (hasAnswered) return;

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
                                            hasAnswered =
                                                true; // Đánh dấu rằng người dùng đã chọn đúng câu trả lời
                                            endgame(filteredData);
                                          } else {
                                            optionColor[index] = Colors.red;
                                            listincorrectAnswer.add(id);
                                            HapticFeedback.heavyImpact();
                                            hasAnswered = true;
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
                                                    // height: double.minPositive,
                                                    child: Text(
                                                      textAlign:
                                                          TextAlign.justify,
                                                      filteredData[
                                                              currentIndexOfQuestion]
                                                          ['correct_answer'],
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .green.shade700,
                                                      ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(content);
                                                        endgame(filteredData);
                                                      },
                                                      child: const Icon(Icons
                                                          .cancel_outlined),
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
                                        style: GoogleFonts.notoMusic(
                                          fontSize: 20,
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
                          child: Text(
                            "Không có câu hỏi nào phù hợp",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
