import 'dart:convert';
import 'package:dssstudentfe/Models/AhpModel.dart';
import 'package:dssstudentfe/Models/ahp_matrix_request.dart';
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
  Future<void> calculateAlternative(AhpMatrixRequest request) async {

    final response = await http.post(
      Uri.parse("$baseUrl/alternative"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if(response.statusCode != 200){
      throw Exception("Error calculating alternative");
    }
  }
  Future<Map<String,dynamic>> getFinalResult() async {

    final response = await http.get(Uri.parse("$baseUrl/final"));

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }

    throw Exception("Error final result");
  }

}