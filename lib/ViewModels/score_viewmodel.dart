import 'package:flutter/material.dart';
import '../Models/ScoreInput.dart';
import '../Services/score_service.dart';

class ScoreViewModel extends ChangeNotifier {

  final ScoreService service = ScoreService();

  bool isLoading = false;

  Future submitScore(
      int studentId,
      double testScore,
      int attendance,
      int studyHours
      ) async {

    isLoading = true;
    notifyListeners();

    ScoreInput score = ScoreInput(

      studentId: studentId,
      testScore: testScore,
      attendance: attendance,
      studyHours: studyHours,

    );

    await service.submitScore(score);

    isLoading = false;
    notifyListeners();

  }

}