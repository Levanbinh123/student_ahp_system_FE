import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/ScoreInput.dart';

class ScoreService {

  Future submitScore(ScoreInput score) async {

    var response = await http.post(

        Uri.parse("http://localhost:5045/api/performance"),

        headers: {
          "Content-Type":"application/json"
        },

        body: jsonEncode(score.toJson())

    );

    return response.body;

  }

}