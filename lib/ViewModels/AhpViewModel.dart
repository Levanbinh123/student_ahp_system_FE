import 'package:dssstudentfe/Models/AhpModel.dart';
import 'package:dssstudentfe/Models/ahp_matrix_request.dart';
import 'package:dssstudentfe/Models/ahp_report.dart';
import 'package:dssstudentfe/Services/AhpService.dart';
import 'package:flutter/material.dart';

class AhpViewModel extends ChangeNotifier {

  final AhpService _service = AhpService();
  AhpReport? report;
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
  Future<void> calculateAlternative(
      String criteria,
      List<List<double>> matrix
      ) async {

    final request = AhpMatrixRequest(
        criteriaName: criteria,
        matrix: matrix
    );

    await _service.calculateAlternative(request);
  }
  Future<void>fetchReport()async{
    try{
      isLoading=true;
      error=null;
      notifyListeners();
      report=await _service.getReposrt();
    }catch(e){
      error=e.toString();
    }finally{
      isLoading=false;
      notifyListeners();
    }
  }
}