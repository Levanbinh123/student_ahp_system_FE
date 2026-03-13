class AhpModel {

  double testAttendance;
  double testStudy;
  double attendanceStudy;

  AhpModel({
    required this.testAttendance,
    required this.testStudy,
    required this.attendanceStudy,
  });

  Map<String, dynamic> toJson() {
    return {
      "test_Attendance": testAttendance,
      "test_Study": testStudy,
      "attendance_Study": attendanceStudy
    };
  }
}

class AhpResult {
  final double testWeight;
  final double attendanceWeight;
  final double studyWeight;
  final double consistencyRatio;
  final bool isConsistent;

  AhpResult({
    required this.testWeight,
    required this.attendanceWeight,
    required this.studyWeight,
    required this.consistencyRatio,
    required this.isConsistent,
  });

  factory AhpResult.fromJson(Map<String, dynamic> json) {
    return AhpResult(
      testWeight: json["testWeight"],
      attendanceWeight: json["attendanceWeight"],
      studyWeight: json["studyWeight"],
      consistencyRatio: json["consistencyRatio"],
      isConsistent: json["isConsistent"],
    );
  }
}