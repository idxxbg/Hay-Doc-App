import 'dart:convert';

import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart';

// var dio = Dio();
var apiLink = "http://idxxbg.xp3.biz/API/haydoc/json_server/Insight.json";

// var apiLink1 = "https://opentdb.com/api.php?amount=20&category=18";

// var api = "http://localhost:3000/insight";
// final url =
//     'https://cors-anywhere.herokuapp.com/http://idxxbg.xp3.biz/API/haydoc/Insight.json';

// getQuizData() async {
//   final res = await http.get(Uri.parse(apiLink));
//   print(res.statusCode);
//   if (res.statusCode == 200) {
//     dynamic data = await jsonDecode(utf8.decode(res.bodyBytes));
//     return data;
//   }
// }

Future<void> getQuizData() async {
  // final url = apiLink; // Thay đổi URL này thành URL của bạn

  try {
    final response = await http.get(
      Uri.parse(apiLink),
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
