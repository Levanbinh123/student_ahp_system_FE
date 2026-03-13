import 'package:dssstudentfe/Models/AhpModel.dart';
import 'package:dssstudentfe/Services/AhpService.dart';
import 'package:flutter/material.dart';

class AhpViewModel extends ChangeNotifier {

  final AhpService _service = AhpService();

  bool isLoading = false;

  Map<String,double>? weights;
  double? cr=0;
  String? error;

  Future<void> calculateAHP(
      double testAttendance,
      double testStudy,
      double attendanceStudy) async {

    isLoading = true;
    notifyListeners();

    try {

      AhpModel model = AhpModel(
        testAttendance: testAttendance,
        testStudy: testStudy,
        attendanceStudy: attendanceStudy,
      );

      var result = await _service.calculate(model);

      weights = {
        "Điểm quá trình": result.testWeight,
        "Số buổi vắng": result.attendanceWeight,
        "Điểm bài tập": result.studyWeight,
      };

      cr = result.consistencyRatio;

    } catch(e) {
    print(e);
    }

    isLoading = false;
    notifyListeners();
  }
}