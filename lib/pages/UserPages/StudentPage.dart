
import 'dart:typed_data';

import 'package:dssstudentfe/Models/Student.dart';
import 'package:dssstudentfe/ViewModels/risk_viewmodel.dart';
import 'package:dssstudentfe/ViewModels/score_viewmodel.dart';
import 'package:dssstudentfe/ViewModels/student_viewmodel.dart';
import 'package:dssstudentfe/pages/UserPages/student_edit_page.dart';
import 'package:dssstudentfe/pages/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;

class StudentPage extends StatefulWidget {
  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<StudentViewModel>().loadStudents();
      context.read<RiskViewModel>().loadResults();
      context.read<ScoreViewModel>().loadScores();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isUpdate=false;

    return Consumer<StudentViewModel>(
        builder: (context, vm, child) {

          final students = vm.students;

          /// SEARCH FILTER
          final displayList = searchController.text.isEmpty
              ? students
              : students.where((s) =>
          s.studentCode.toLowerCase().contains(searchController.text.toLowerCase()) ||
              s.name.toLowerCase().contains(searchController.text.toLowerCase()) ||
              s.className.toLowerCase().contains(searchController.text.toLowerCase())
          ).toList();

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue.shade800,
              title: Text("Quản lý sinh viên", style: TextStyle(color: Colors.grey.shade200),),
            ),
            drawer: MyDrawer(currentPage: "/students"),
            backgroundColor: Color(0xfff5f7fb),

            body: Padding(
              padding: EdgeInsets.all(20),

              child: Column(
                children: [

                  /// SEARCH + ADD
                  Row(
                    children: [

                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: (text){
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: "Tìm kiếm theo mã SV, tên, lớp...",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                      SizedBox(width: 10),

                      Row(
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              showAddStudentDialog(context);
                            },
                            icon: Icon(Icons.add, color: Colors.white),
                            label: Text(
                              "Thêm sinh viên",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
                              uploadInput.accept = ".xlsx";
                              uploadInput.click();

                              uploadInput.onChange.listen((e) async {
                                final files = uploadInput.files;
                                if (files != null && files.isNotEmpty) {
                                  final file = files.first;
                                  final reader = html.FileReader();
                                  reader.readAsArrayBuffer(file);
                                  reader.onLoadEnd.listen((e) async {
                                    final bytes = reader.result as Uint8List;
                                    try {
                                      await context.read<StudentViewModel>().importExcelWeb(bytes, file.name);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Import thành công!"))
                                      );
                                    } catch (ex) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Import thất bại: $ex"))
                                      );
                                    }
                                  });
                                }
                              });
                            },
                            icon: Icon(Icons.upload_file),
                            label: Text("Import Excel"),
                          ),
                          const SizedBox(width: 20,),
                          ElevatedButton(

                            onPressed: context.watch<RiskViewModel>().isLoading?null:()async{
                              await context.read<RiskViewModel>().calculateAll();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Đã tính risk cho tất cả học sinh"))
                              );
                            },
                            child: Text("Tính Risk "),
                          ),
                        ],
                      )
                    ],
                  ),

                  SizedBox(height: 20),

                  /// TABLE
                  Expanded(
                    child: Container(

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ],
                      ),

                      child: vm.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Mã SV")),
                            DataColumn(label: Text("Họ tên")),
                            DataColumn(label: Text("Lớp")),
                            DataColumn(label: Text("Email")),
                            DataColumn(label: Text("Test")),
                            DataColumn(label: Text("Attendance")),
                            DataColumn(label: Text("Study")),
                            DataColumn(label: Text("Mức rủi ro")),
                            DataColumn(label: Text("Thao tác")),
                          ],

                          rows: displayList.map((s){

                            return DataRow(

                              cells: [

                                DataCell(Text(s.studentCode)),

                                DataCell(Text(s.name)),

                                DataCell(Text(
                                    s.className.isEmpty
                                        ? "Chưa có lớp"
                                        : s.className
                                )),

                                DataCell(Text(
                                    s.email.isEmpty
                                        ? "Chưa có email"
                                        : s.email
                                )),

                                //diem hoc sinh
                                DataCell(
                                  Consumer<ScoreViewModel>(
                                    builder: (context, scoreVm,_){
                                      final score=scoreVm.getScoreByStudent(s.id!);
                                      return Text(score?.testScore.toString()??"-");
                                    },
                                  )
                                ),
                                DataCell(
                                  Consumer<ScoreViewModel>(
                                    builder: (context, scoreVm, _) {
                                      final score = scoreVm.getScoreByStudent(s.id!);
                                      return Text(score?.attendance.toString() ?? "-");
                                    },
                                  ),
                                ),
                                DataCell(
                                  Consumer<ScoreViewModel>(
                                    builder: (context, scoreVm, _) {
                                      final score = scoreVm.getScoreByStudent(s.id!);
                                      return Text(score?.attendance.toString() ?? "-");
                                    },
                                  ),
                                ),
                                    ////risk
                                DataCell(
                                  Consumer<RiskViewModel>(
                                    builder: (context, riskVm, child) {

                                      final risk = riskVm.getRiskByStudent(s.id!);

                                      String level = risk?.riskLevel ?? "Chưa tính";

                                      Color color = Colors.grey;

                                      if(level == "High Risk") color = Colors.red;
                                      if(level == "Medium Risk") color = Colors.orange;
                                      if(level == "Low Risk") color = Colors.green;

                                      return Container(
                                        padding: EdgeInsets.symmetric(horizontal:10, vertical:4),
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          level,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      );

                                    },
                                  ),
                                ),

                                DataCell(
                                  Row(
                                    children: [

                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentEditPage(student: s)));
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () async {

                                        },
                                      ),
                                      //ahp



                                    ],
                                  ),
                                )

                              ],

                            );

                          }).toList(),

                        ),
                      ),

                    ),
                  )

                ],
              ),
            ),
          );
        }
    );
  }


  /// ADD STUDENT DIALOG
  void showAddStudentDialog(BuildContext context,{Student? student}){

    TextEditingController code =
    TextEditingController(text: student?.studentCode ?? "");
    TextEditingController name =
    TextEditingController(text: student?.name ?? "");
    TextEditingController className =
    TextEditingController(text: student?.className ?? "");
    TextEditingController email =
    TextEditingController(text: student?.email ?? "");

    showDialog(
        context: context,
        builder: (context){

          return AlertDialog(

            title: Text(student == null
                ? "Thêm sinh viên"
                : "Cập nhật sinh viên"),

            content: Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                TextField(
                  controller: code,
                  decoration: InputDecoration(labelText: "Mã SV"),
                ),

                TextField(
                  controller: name,
                  decoration: InputDecoration(labelText: "Họ tên"),
                ),

                TextField(
                  controller: className,
                  decoration: InputDecoration(labelText: "Lớp"),
                ),

                TextField(
                    controller: email,
                    decoration: InputDecoration(labelText: "Email")
                ),

              ],
            ),

            actions: [

              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Huỷ")
              ),

              ElevatedButton(

                onPressed: () async {

                    await context.read<StudentViewModel>().addStudent(
                        code.text,
                        name.text,
                        className.text,
                        email.text
                    );

                  Navigator.pop(context);
                },
                child: Text("Lưu"),
              )

            ],

          );
        }
    );
  }

}
