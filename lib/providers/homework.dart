import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helpers/envs.dart';

class HomeWork extends ChangeNotifier {
  // -- Functions --
  // sendHomeWork
  // getHwByClass
  // deleteHw
  String baseUrl = Envs.baseUrl;

  Future<void> sendHomeWork(Map<String, dynamic> homework, String token) async {
    var headers = {'Authorization': 'Token $token'};
    var request =
        http.MultipartRequest('POST', Uri.parse(baseUrl + '/manage/addhw'));

    request.fields.addAll({
      'icerik': homework["içerik"],
      'baslik': homework["başlık"],
      'bitis_tarihi': homework["bitiş_tarihi"],
      'sinif': '11',
      'sube': 'a',
      'aciklama': homework["açıklama"]
    });
    request.files.add(
      await http.MultipartFile.fromPath(
        'dosya',
        homework["file_path"],
      ),
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<List<dynamic>> getHwByClass(String token) async {
    var headers = {'Authorization': 'Token $token'};
    final response = await http.get(
      Uri.parse(baseUrl + "/manage/gethw/11-a"),
      headers: headers,
    );
    final normalResponse = utf8.decode(response.bodyBytes);
    final normalJson = json.decode(normalResponse) as List<dynamic>;

    return normalJson;
  }

  Future<void> deleteHw(int id, String token) async {
    var headers = {'Authorization': 'Token $token'};
    final response = await http.delete(
      Uri.parse(baseUrl + "/manage/delhw/$id"),
      headers: headers,
    );
    // notifyListeners();

    if (response.statusCode != 204) {
      final normalResponse = utf8.decode(response.bodyBytes);
      final normalJson = json.decode(normalResponse);

      print(normalJson);
    }
  }
}
