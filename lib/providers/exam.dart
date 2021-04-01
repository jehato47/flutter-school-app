import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/sinav.dart';
import '../helpers/envs.dart';

class Exam extends ChangeNotifier {
  // -- Functions --
  // setExams
  // sendExcel
  // getStudentResults
  final baseUrl = Envs.baseUrl;

  Future<void> setExams(String token) async {
    var headers = {'Authorization': 'Token $token'};
    final response = await http.get(
      Uri.parse(baseUrl + "/exam/set"),
      headers: headers,
    );
    print(json.decode(response.body));
  }

  Future<Map<String, dynamic>> getExcel(String token, String classes) async {
    var headers = {'Authorization': 'Token $token'};
    final response = await http.get(
      Uri.parse(baseUrl + "/exam/cxl/" + classes),
      headers: headers,
    );

    final normalResponse = utf8.decode(response.bodyBytes);
    final normalJson = json.decode(normalResponse);
    return normalJson;
  }

  Future<void> sendExcel(String token, String filePath) async {
    var headers = {'Authorization': 'Token $token'};
    var request =
        http.MultipartRequest('POST', Uri.parse(baseUrl + '/exam/xl'));
    request.files.add(
      await http.MultipartFile.fromPath('exams', filePath),
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<List<Sinav>> getStudentResults(String token) async {
    List<Sinav> _sinavlar = [];
    var headers = {'Authorization': 'Token $token'};
    final response = await http.get(
      Uri.parse(baseUrl + "/exam/res/21"),
      headers: headers,
    );

    final normalResponse = utf8.decode(response.bodyBytes);
    final normalJson = json.decode(normalResponse) as Map;
    final dersler = [
      'matematik',
      'fizik',
      'kimya',
      'biyoloji',
      'türk_dili',
      'edebiyat',
      'sosyal',
      'cografya'
    ];

    dersler.forEach((element) {
      var e = normalJson[element] as Map;
      if (e.isNotEmpty) {
        // TODO : Her zaman 3 tane sınav olmayabilir
        _sinavlar.add(
          Sinav(
            element,
            e["1"]["not"] != -1 ? e["1"]["not"] : 0,
            e["2"]["not"] != -1 ? e["2"]["not"] : 0,
            e["3"]["not"] != -1 ? e["3"]["not"] : 0,
          ),
        );
      } else {
        _sinavlar.add(
          Sinav(element, 0, 0, 0),
        );
      }
    });
    return _sinavlar;
  }
}
