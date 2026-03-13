import 'package:dssstudentfe/pages/AhpComparisonPage.dart';
import 'package:dssstudentfe/pages/components/my_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AhpCriteriaPage extends StatefulWidget {
  @override
  _AhpCriteriaPageState createState() => _AhpCriteriaPageState();
}

class _AhpCriteriaPageState extends State<AhpCriteriaPage> {

  List<String> criteria = [
    "Điểm quá trình",
    "Điểm bài tập",
    "Mức độ tham gia"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue.shade800,
        title: Text("AHP Criteria"),),
      drawer:MyDrawer(currentPage: "/ahp"),
      backgroundColor: Color(0xfff5f7fb),
      body: Center(
              child: Container(
                width: 500,
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

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// TITLE
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Quản lý tiêu chí đánh giá",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    SizedBox(height: 5),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Các tiêu chí để đánh giá rủi ro sinh viên",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 10),
                    /// LIST TITLE
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Danh sách tiêu chí (${criteria.length})",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    /// CRITERIA LIST
                    Column(
                      children: List.generate(criteria.length, (index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),

                          decoration: BoxDecoration(
                            color: Color(0xffe6f0ff),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.blue.shade800,
                                child: Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white),
                                ),
                              ),

                              SizedBox(width: 5),
                              Expanded(
                                child: Text(criteria[index]),
                              ),

                            ],
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 10),

                    /// NEXT BUTTON
                    Expanded(

                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade800,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>AhpComparisonPage()));
                            },
                            child: Container(
                              child: Text("Tiếp theo: So sánh cặp",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                  color: Colors.white),),
                            ),
                          ),
                        ),
                      ),

                  ],
                ),
              ),
            ),
    );
  }

}