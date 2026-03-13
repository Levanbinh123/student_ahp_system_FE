class ScoreInput {

  int studentId;
  double testScore;
  int attendance;
  int studyHours;

  ScoreInput({
    required this.studentId,
    required this.testScore,
    required this.attendance,
    required this.studyHours,
  });

  Map<String,dynamic> toJson(){
    return {
      "studentId": studentId,
      "testScore": testScore,
      "attendance": attendance,
      "studyHours": studyHours
    };
  }
  factory ScoreInput.fromJson(Map<String, dynamic> json) {
    return ScoreInput(
     studentId: json["studentId"],
      testScore: json["testScore"],
      attendance: json["attendance"],
      studyHours: json["studyHours"]
    );
  }

}