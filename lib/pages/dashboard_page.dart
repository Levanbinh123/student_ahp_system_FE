import 'package:dssstudentfe/ViewModels/risk_viewmodel.dart';
import 'package:dssstudentfe/pages/components/my_drawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RiskViewModel>().loadSummary();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: Text("Dashboard", style: TextStyle(color: Colors.grey.shade200),),
      ),
      drawer: MyDrawer(currentPage: "/dashboard"),
      body: Consumer<RiskViewModel>(
        builder: (context, vm, _) {

          if (vm.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (vm.summary == null) {
            return Center(child: Text("No data"));
          }

          return Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 400,
                    width: 400,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1,

                          children: [

                            buildCard("Rủi ro thấp", vm.summary!['low'], Colors.green.shade400),
                            buildCard("Rủi ro trung bình", vm.summary!['medium'], Colors.orange.shade400),
                            buildCard("Rủi ro cao", vm.summary!['high'], Colors.red.shade400),
                            buildCard("Tổng số sinh viên", vm.summary!['total'], Colors.blue.shade400),

                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),

            ],
          );
        },
      ),
    );
  }
}
Widget buildCard(String title, int value, Color color) {
  return Container(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      color: color, // nền trắng cho nổi viền

      borderRadius: BorderRadius.circular(16),


      border: Border.all(
        color: color,   // màu viền
        width: 3,
      ),

      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
        )
      ],
    ),

    padding: EdgeInsets.all(16),

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 10),

        Text(
          value.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
Widget buildBarChart(Map<String, dynamic> summary) {
  final low = summary['low'] ?? 0;
  final medium = summary['medium'] ?? 0;
  final high = summary['high'] ?? 0;
  final total=low+medium+high;
  double lowP = total == 0 ? 0 : (low / total) * 100;
  double mediumP = total == 0 ? 0 : (medium / total) * 100;
  double highP = total == 0 ? 0 : (high / total) * 100;


  return SizedBox(
    height: 300,
    child: BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,

        barTouchData: BarTouchData(enabled: true),

        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return Text("Low");
                  case 1:
                    return Text("Medium");
                  case 2:
                    return Text("High");
                }
                return Text("");
              },
            ),
          ),
        ),

        borderData: FlBorderData(show: false),

        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: low.toDouble(),
                color: Colors.green,
                width: 20,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: medium.toDouble(),
                color: Colors.orange,
                width: 20,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: high.toDouble(),
                color: Colors.red,
                width: 20,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}