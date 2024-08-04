import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  // var listincorrectAnswer;

  const ResultScreen({
    super.key,
    required this.listcorrectAnswser,
    required this.listincorrectAnswser,
  });

  final List<dynamic> listcorrectAnswser;
  final List<dynamic> listincorrectAnswser;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
