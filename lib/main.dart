import 'package:dssstudentfe/ViewModels/AhpViewModel.dart';
import 'package:dssstudentfe/ViewModels/risk_viewmodel.dart';
import 'package:dssstudentfe/ViewModels/score_viewmodel.dart';
import 'package:dssstudentfe/ViewModels/student_viewmodel.dart';
import 'package:dssstudentfe/pages/AhpCriteriaPage.dart';
import 'package:dssstudentfe/pages/AhpReportPage.dart';
import 'package:dssstudentfe/pages/UserPages/StudentPage.dart';
import 'package:dssstudentfe/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => StudentViewModel(),
      ),
      ChangeNotifierProvider(
        create: (_) => ScoreViewModel(),
      ),
      ChangeNotifierProvider(
        create: (_) => AhpViewModel(),
      ),
      ChangeNotifierProvider(
        create: (_) => RiskViewModel(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/dashboard",
    routes: {
        "/dashboard":(context)=>DashboardPage(),
         "/students": (context) => StudentPage(),
        "/ahp": (context) => AhpCriteriaPage(),
       "/ahp-report":(context)=>AhpReportPage()
    },
      title: 'DSS Cảnh Báo Sớm',
      debugShowCheckedModeBanner: false,
      home: DashboardPage(),
    );
  }
}