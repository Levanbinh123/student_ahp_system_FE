import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {

  final String currentPage;

  const MyDrawer({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {

    return Drawer(

      child: ListView(

        children: [

          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue.shade800,
            ),

            child: Text(
              "DSS Cảnh Báo Sớm",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          menuItem(context, Icons.dashboard, "Dashboard", "/dashboard"),
          menuItem(context, Icons.people, "Sinh viên", "/students"),
          menuItem(context, Icons.analytics, "AHP", "/ahp"),
          menuItem(context, Icons.report, "Báo cáo AHP", "/ahp-report"),

        ],
      ),
    );
  }

  Widget menuItem(
      BuildContext context,
      IconData icon,
      String title,
      String route,
      ) {

    bool active = currentPage == route;

    return ListTile(

      leading: Icon(icon, color: active ? Colors.blue : null),

      title: Text(
        title,
        style: TextStyle(
          color: active ? Colors.blue : null,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),

      tileColor: active ? Colors.blue.withOpacity(0.1) : null,

      onTap: () {

        Navigator.pop(context);

        if (!active) {
          Navigator.pushReplacementNamed(context, route);
        }

      },

    );
  }
}