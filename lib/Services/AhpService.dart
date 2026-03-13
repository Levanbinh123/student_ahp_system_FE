import 'dart:convert';
import 'package:dssstudentfe/Models/AhpModel.dart';
import 'package:http/http.dart' as http;

class AhpService {

  final String baseUrl = "http://localhost:5045/api/ahp";

  Future<AhpResult> calculate(AhpModel model) async {

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(model.toJson()),
    );

    final body=jsonDecode(response.body);
    if (response.statusCode == 200 && body["success"] == true) {
      return AhpResult.fromJson(body["data"]);
    }

    throw Exception(body["message"]);
  }
}