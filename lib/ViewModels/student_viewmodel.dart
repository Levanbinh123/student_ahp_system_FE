import 'package:flutter/material.dart';
import '../Models/Student.dart';
import '../Services/student_service.dart';

class StudentViewModel extends ChangeNotifier {

  final StudentService _service = StudentService();
  bool isLoading=false;

  List<Student> students = [];

  Future<void> addStudent(
      String code,
      String name,
      String className,
      String email
      ) async {

    Student s = Student(
        studentCode: code,
        name: name,
        className: className,
      email: email,
      listPer: []
    );

    Student? created = await _service.createStudent(s);

    if(created != null){
      students.add(created);
      notifyListeners();
    }
  }
  Future<void> loadStudents()async{
    isLoading = true;
    notifyListeners();
    students = await _service.GetAllStudent();
    isLoading=false;
    notifyListeners();
  }
}