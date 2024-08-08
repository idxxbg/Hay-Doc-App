import 'dart:convert';

import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart';

// var dio = Dio();
var insight = "http://idxxbg.xp3.biz/API/haydoc/json_server/Insight.json";
var history = "http://idxxbg.xp3.biz/API/haydoc/json_server/history.json";
var test = "http://idxxbg.xp3.biz/API/haydoc/json_server/test.json";

// var apiLink1 = "https://opentdb.com/api.php?amount=20&category=18";

Future<void> getQuizData() async {
  // final url = apiLink; // Thay đổi URL này thành URL của bạn

  try {
    final response = await http.get(
      Uri.parse(insight),
      // headers: {"Content-Type": "application/json; charset=utf-8"},
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      // Nếu máy chủ trả về mã trạng thái 200, thì phân tích cú pháp JSON.
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      // print(data);
      return data;
      // Xử lý dữ liệu JSON ở đây
    } else {
      // Nếu máy chủ không trả về mã trạng thái 200, hãy ném một ngoại lệ.
      throw Exception('Failed to load JSON data');
    }
  } catch (e) {
    // print(response.statusCode);
    print('Error: $e');
    // Xử lý lỗi nếu cần
  }
}

Future<void> getQuizData2() async {
  // final url = apiLink; // Thay đổi URL này thành URL của bạn

  try {
    final response = await http.get(
      Uri.parse(history),
      // headers: {"Content-Type": "application/json; charset=utf-8"},
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      // Nếu máy chủ trả về mã trạng thái 200, thì phân tích cú pháp JSON.
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      // print(data);
      return data;
      // Xử lý dữ liệu JSON ở đây
    } else {
      // Nếu máy chủ không trả về mã trạng thái 200, hãy ném một ngoại lệ.
      throw Exception('Failed to load JSON data');
    }
  } catch (e) {
    // print(response.statusCode);
    print('Error: $e');
    // Xử lý lỗi nếu cần
  }
}

Future<void> getQuizData3() async {
  // final url = apiLink; // Thay đổi URL này thành URL của bạn

  try {
    final response = await http.get(
      Uri.parse(history),
      // headers: {"Content-Type": "application/json; charset=utf-8"},
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      // Nếu máy chủ trả về mã trạng thái 200, thì phân tích cú pháp JSON.
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      // print(data);
      return data;
      // Xử lý dữ liệu JSON ở đây
    } else {
      // Nếu máy chủ không trả về mã trạng thái 200, hãy ném một ngoại lệ.
      throw Exception('Failed to load JSON data');
    }
  } catch (e) {
    // print(response.statusCode);
    print('Error: $e');
    // Xử lý lỗi nếu cần
  }
}
