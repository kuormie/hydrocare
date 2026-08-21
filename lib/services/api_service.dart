import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "http://10.177.47.4:5000/model/predict/";

  Future<Map<String, dynamic>> predictImage(File image) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(baseUrl),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // <-- GANTI DARI 'file' MENJADI 'image'
          image.path,
        ),
      );

      var response = await request.send();

      var responseBody = await response.stream.bytesToString();

      print("STATUS CODE : ${response.statusCode}");
      print("BODY : $responseBody");

      if (response.statusCode == 200) {
        return jsonDecode(responseBody);
      } else {
        throw Exception(responseBody);
      }
    } catch (e) {
      print("===== ERROR API =====");
      print(e.toString());
      throw Exception("Gagal menghubungi server : $e");
    }
  }
}