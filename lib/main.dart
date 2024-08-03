import 'package:flutter/material.dart';
import 'package:hay_doc_app/style.dart';

import 'screen/my_home_page.dart';

void main() {
  runApp(const HayDocApp());
}

class HayDocApp extends StatelessWidget {
  const HayDocApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
