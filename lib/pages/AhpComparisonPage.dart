import 'package:dssstudentfe/ViewModels/AhpViewModel.dart';
import 'package:dssstudentfe/pages/AhpResultPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AhpComparisonPage extends StatefulWidget {
  @override
  State<AhpComparisonPage> createState() => _AhpComparisonPageState();
}

class _AhpComparisonPageState extends State<AhpComparisonPage> {

  List<String> criteria = [
    "Điểm quá trình",
    "Số buổi vắng",
    "Điểm bài tập"
  ];

  List<String> saatyScale = [
    "1 - Ngang nhau",
    "3 - Hơi quan trọng hơn",
    "5 - Quan trọng hơn",
    "7 - Rất quan trọng",
    "9 - Cực kỳ quan trọng"
  ];

  Map<String, String> selectedValues = {};

  List<Map<String, String>> pairs = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < criteria.length; i++) {
      for (int j = i + 1; j < criteria.length; j++) {

        String key = "${criteria[i]}|${criteria[j]}";

        pairs.add({
          "a": criteria[i],
          "b": criteria[j],
          "key": key
        });

        selectedValues[key] = saatyScale[0];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("So sánh các cặp tiêu chí",style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.blue.shade800,),

      backgroundColor: Color(0xfff5f7fb),

      body: Center(
        child: Container(

          width: 600,
          padding: EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black12,
              )
            ],
          ),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),

                /// TITLE
                Text(
                  "So sánh cặp các tiêu chí",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  "So sánh mức độ quan trọng giữa các cặp tiêu chí theo thang đo Saaty (1-9)",
                  style: TextStyle(color: Colors.grey),
                ),

                SizedBox(height: 20),

                /// PAIRS
                Column(
                  children: pairs.map((pair) {

                    String key = pair["key"]!;

                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            "So sánh: ${pair["a"]} với ${pair["b"]}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          SizedBox(height: 8),

                          DropdownButtonFormField<String>(
                            value: selectedValues[key],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            items: saatyScale.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedValues[key] = value!;
                              });
                            },
                          )
                        ],
                      ),
                    );

                  }).toList(),
                ),

                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Hướng dẫn thang đo Saaty:",
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue.shade800),
                      ),

                      SizedBox(height: 8),

                      Text("1 : Hai tiêu chí có mức độ quan trọng ngang nhau",style: TextStyle(color: Colors.blue.shade900),),
                      Text("3 : Tiêu chí thứ nhất hơi quan trọng hơn",style: TextStyle(color: Colors.blue.shade900)),
                      Text("5 : Tiêu chí thứ nhất quan trọng hơn",style: TextStyle(color: Colors.blue.shade900)),
                      Text("7 : Tiêu chí thứ nhất rất quan trọng",style: TextStyle(color: Colors.blue.shade900)),
                      Text("9 : Tiêu chí thứ nhất cực kỳ quan trọng",style: TextStyle(color: Colors.blue.shade900)),

                    ],
                  ),
                ),

                SizedBox(height: 20),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async{

                      var vm = context.read<AhpViewModel>();

                      double testAttendance = _convertScale(
                          selectedValues["Điểm quá trình|Số buổi vắng"]!
                      );

                      double testStudy = _convertScale(
                          selectedValues["Điểm quá trình|Điểm bài tập"]!
                      );

                      double attendanceStudy = _convertScale(
                          selectedValues["Số buổi vắng|Điểm bài tập"]!
                      );

                      await vm.calculateAHP(
                          testAttendance,
                          testStudy,
                          attendanceStudy
                      );

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)=>AhpResultPage(
                                weights: vm.weights!,
                                cr: vm.cr!,
                              )
                          )
                      );

                    },
                    child: Text(
                      "Tính trọng số",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  double _convertScale(String value){

    if(value.startsWith("1")) return 1;
    if(value.startsWith("3")) return 3;
    if(value.startsWith("5")) return 5;
    if(value.startsWith("7")) return 7;
    if(value.startsWith("9")) return 9;

    return 1;
  }
}