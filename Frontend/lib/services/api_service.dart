import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://localhost:5000";

  Future<Map<String, dynamic>> uploadPdf(File pdfFile, String userId) async {
    var request = http.MultipartRequest("POST", Uri.parse("$baseUrl/upload_pdf"));
    request.files.add(await http.MultipartFile.fromPath('file', pdfFile.path));
    request.fields['user_id'] = userId;

    var response = await request.send();
    if (response.statusCode == 200) {
      var resData = await http.Response.fromStream(response);
      return jsonDecode(resData.body);
    } else {
      throw Exception("Failed to upload PDF");
    }
  }

  Future<String> askQuestion(String question, String userId, int pdfId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/ask_question"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "user_id": userId,
        "question": question,
        "pdf_id": pdfId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['answer'];
    } else {
      throw Exception("Failed to get answer");
    }
  }
}
