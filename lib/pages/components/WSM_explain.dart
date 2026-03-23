import 'package:flutter/material.dart';

Widget WSMInfoPage()  {
    return  Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue.shade800
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Sau khi đã có trọng số tiêu chí và tổng số theo từng phương án thì tiến hành sử dụng: Weighted Sum Model (WSM) để tính và phân loại mức rủi ra cho từng sinh viên :",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey.shade300),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Công thức tổng quát:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "Score của lựa chọn Ai = Σ (wj * aij) từ j=1 đến n",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 10),
              Text(
                "Trong đó:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "• aij = giá trị của lựa chọn i theo tiêu chí j\n"
                    "• wj = trọng số của tiêu chí j\n"
                    "• n = số tiêu chí",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Điều kiện: tất cả các giá trị aij phải cùng thang đo",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),

    );
  }