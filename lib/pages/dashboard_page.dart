import 'package:dssstudentfe/pages/components/my_drawer.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: Text("Dashboard", style: TextStyle(color: Colors.grey.shade200),),
      ),
      drawer: MyDrawer(currentPage: "/dashboard"),
      body: Center(child: Text("Dashboard"),),
    );
  }
}
