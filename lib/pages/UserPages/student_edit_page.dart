import 'package:dssstudentfe/Models/Student.dart';
import 'package:dssstudentfe/ViewModels/risk_viewmodel.dart';
import 'package:dssstudentfe/ViewModels/score_viewmodel.dart';
import 'package:dssstudentfe/ViewModels/student_viewmodel.dart';
import 'package:dssstudentfe/pages/components/my_ahp_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class StudentEditPage extends StatefulWidget {

  final Student student;

  const StudentEditPage({super.key, required this.student});

  @override
  State<StudentEditPage> createState() => _StudentEditPageState();
}

class _StudentEditPageState extends State<StudentEditPage> {

  late TextEditingController codeController;
  late TextEditingController nameController;
  late TextEditingController classController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();

    codeController = TextEditingController(text: widget.student.studentCode);
    nameController = TextEditingController(text: widget.student.name);
    classController = TextEditingController(text: widget.student.className);
    emailController = TextEditingController(text: widget.student.email);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Color(0xfff5f7fb),

      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: Text("Chỉnh sửa sinh viên", style: TextStyle(color: Colors.white),),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
          
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                )
              ],
            ),
          
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
          
              children: [
          
                /// TITLE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Chỉnh sửa thông tin sinh viên",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          widget.student.listPer!.isEmpty ? Colors.blue.shade400 : Colors.blue.shade500,
                        ),
                        onPressed: () {

                          showScoreDialog(context, studentId: widget.student.id);
                        },
                        child: widget.student.listPer!.isEmpty?Text("Nhập dữ liệu tính AHP"):Text("Cập nhật dữ liệu tính AHP", style: TextStyle(color: Colors.grey[900],fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(width: 20,),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade800,
                          ),
                          onPressed: ()async{
                            await context.read<RiskViewModel>().calculateRisk(widget.student.id!);
                            await context.read<RiskViewModel>().loadResults();
                          }, child: Text("Tính AHP",style: TextStyle(color: Colors.grey[200]),))
                    ],
                  )
                  ],
                ),
          
                SizedBox(height: 8),
          
                Text(
                  "Cập nhật thông tin của sinh viên ${widget.student.studentCode}",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
          
                SizedBox(height: 25),
          
                /// STUDENT CODE
                Text("Mã sinh viên"),
          
                SizedBox(height: 6),
          
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(),
                  ),
                ),
          
                SizedBox(height: 16),
          
                /// NAME
                Text("Họ tên"),
          
                SizedBox(height: 6),
          
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(),
                  ),
                ),
          
                SizedBox(height: 16),
          
                /// CLASS
                Text("Lớp"),
          
                SizedBox(height: 6),
          
                TextField(
                  controller: classController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                /// EMAIL
                Text("Email"),
                SizedBox(height: 6),
          
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(),
                  ),
                ),
          
                SizedBox(height: 25),
                Consumer<ScoreViewModel>(
                  builder: (context, scoreVm, _) {
                    final score = scoreVm.getScoreByStudent(widget.student.id!);

                    if (score == null) {
                      return Text("Chưa có dữ liệu");
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyAhpCustom(text: "Điểm kiểm tra: ${score.testScore}"),
                        SizedBox(height: 10),
                        MyAhpCustom(text: "Chuyên cần: ${score.attendance}%"),
                        SizedBox(height: 10),
                        MyAhpCustom(text: "Giờ học/ngày: ${score.studyHours}"),
                      ],
                    );
                  },
                ),

                Divider(),
                Consumer<RiskViewModel>(
                  builder: (context, riskVm, child) {

                    final risk = riskVm.getRiskByStudent(widget.student.id!);

                    if(risk == null){
                      return Text(
                        "Chưa tính Risk AHP",
                        style: TextStyle(color: Colors.grey),
                      );
                    }

                    Color color = Colors.green;

                    if(risk.riskLevel == "High Risk") color = Colors.red;
                    if(risk.riskLevel == "Medium Risk") color = Colors.orange;

                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        
                            Text(
                              "Kết quả AHP",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                        
                            SizedBox(height: 10),
                        
                            Text("Risk Score: ${risk.riskScore.toStringAsFixed(2)}"),
                        
                            Text(
                              "Risk Level: ${risk.riskLevel}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: color,
                                fontSize: 16,
                              ),
                            ),
                        
                          ],
                        ),
                      ),
                    );
                  },
                ),
                ///ket thuc
                Divider(),
          
                SizedBox(height: 10),
          
                /// BUTTONS
                Row(
          
                  children: [
          
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 14,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
          
                      child: Text(
                        "Cập nhật",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
          
                    SizedBox(width: 10),
          
                    OutlinedButton(
          
                      onPressed: () {
                        Navigator.pop(context);
                      },
          
                      child: Text("Hủy"),
                    )
          
                  ],
                )
          
              ],
            ),
          ),
        ),
      ),
    );
  }
  void  showScoreDialog(BuildContext context, {required int? studentId}){
    final scoreVm=context.read<ScoreViewModel>();
    final oldScore=scoreVm.getScoreByStudent(studentId!);
    TextEditingController testScore =
    TextEditingController(text: oldScore?.testScore.toString() ?? "");
    TextEditingController attendance =
    TextEditingController(text: oldScore?.attendance.toString() ?? "");
    TextEditingController studyHours =
    TextEditingController(text: oldScore?.studyHours.toString() ?? "");
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Nhập dữ liệu học tập"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: testScore,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}'))
                  ],
                  decoration: InputDecoration(
                    labelText: "Điểm kiểm tra (0-10)",
                  ),
                ),
                TextField(
                  controller: attendance,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: "Chuyên cần (%)(0-100)",
                  ),
                ),
                TextField(
                  controller: studyHours,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    labelText: "Giờ học/ngày (0-24)",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Hủy")),
              ElevatedButton(
                  onPressed:()async{
                    if (testScore.text.isEmpty ||
                        attendance.text.isEmpty ||
                        studyHours.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Vui lòng nhập đầy đủ dữ liệu")),
                      );
                      return;
                    }
                double score = double.parse(testScore.text)??-1;
                int attend = int.parse(attendance.text)??-1;
                int hours = int.parse(studyHours.text)??-1;
                    if (score < 0 || score > 10) {
                      showError("Điểm phải từ 0 - 10");
                      return;
                    }

                    if (attend < 0 || attend > 100) {
                      showError("Chuyên cần phải từ 0 - 100%");
                      return;
                    }

                    if (hours < 0 || hours > 24) {
                      showError("Giờ học phải từ 0 - 24");
                      return;
                    }
                await context.read<ScoreViewModel>().submitScore(
                  studentId!,
                  score,
                  attend,
                  hours,
                );
                await context.read<ScoreViewModel>().loadScores();
                await context.read<RiskViewModel>().loadResults();
                Navigator.pop(context);
                setState(() {
                });
              }, child: Text("Lưu"))
            ],
          );
        });
  }
  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}