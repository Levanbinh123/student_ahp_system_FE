import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../Models/Student.dart';

class StudentService {

  final String baseUrl = "http://localhost:5045/api/student";

  Future<Student?> createStudent(Student student) async {

    final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode(student.toJson())
    );

    if(response.statusCode == 200){
      return Student.fromJson(jsonDecode(response.body));
    }

    return null;
  }
  Future<List<Student>> GetAllStudent() async {

    final response = await http.get(
      Uri.parse(baseUrl),
    );
    if(response.statusCode == 200){

      List data = jsonDecode(response.body);

      return data.map((e) => Student.fromJson(e)).toList();

    }else{
      throw Exception("Failed");
    }
  }
  /// Import file Excel lên server

}