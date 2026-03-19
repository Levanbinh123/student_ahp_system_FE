import 'package:dssstudentfe/pages/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModels/AhpViewModel.dart';

class AhpReportPage extends StatefulWidget {
  const AhpReportPage({super.key});

  @override
  State<AhpReportPage> createState() => _AhpReportPageState();
}

class _AhpReportPageState extends State<AhpReportPage> {
  @override
  void initState() {
    super.initState();
    // Gọi fetchReport ngay khi trang mở
    // Dùng addPostFrameCallback để context đã sẵn sàng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<AhpViewModel>(context, listen: false);
      vm.fetchReport();
    });
  }
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AhpViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.blue,
        title: const Text("AHP Report", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
      ),
      drawer: MyDrawer(currentPage: "/ahp-report",),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: _buildBody(vm),
        ),
      ),
    );
  }
  Widget _buildBody(AhpViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.error != null) {
      return Center(child: Text("Error: ${vm.error}"));
    }
    if (vm.report == null) {
      return const Center(child: Text("Nhấn nút để load dữ liệu"));
    }
    final r = vm.report!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title("— Xác định tiêu chí"),
          Row(
            children: [
              buildTable(
                headers: ["Tiêu chí", "Ý nghĩa"],
                data: [
                  ["C1", "Test Score (Học thuật)"],
                  ["C2", "Attendance (Kỷ luật)"],
                  ["C3", "Study Hours (Nỗ lực)"],
                ],
              ),
              const SizedBox(width: 70,),
              buildTable(
                headers: ["Ký hiệu", "Phương án","Ý nghĩa"],
                data: [
                  ["A1", "Nguy cơ cao","Sinh viên dễ rớt môn"],
                  ["A2", "Nguy cơ thấp","Có dấu hiệu cảnh báo"],
                  ["A3", "An toàn","Học tập ổn định"],
                ],
              ),
            ],
          ),
          /// ===== BƯỚC 2 =====
          _title("— Ma trận so sánh cặp"),
          ...r.matrices
              .where((m) => m['criteriaName'] == "Criteria") // chỉ lấy ma trận tên Criteria
              .map<Widget>((m) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m['criteriaName'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildMatrix(m['matrix']),
              ],
            );
          }).toList(),
          /// ===== BƯỚC 4 =====
          _title(" — Trọng số tiêu chí"),
          buildTable(
            headers: ["Tiêu chí", "Trọng số"],
            data: r.criteriaWeights.entries
                .map<List<dynamic>>(
                    (e) => [e.key, e.value.toStringAsFixed(3)])
                .toList(),
          ),
          const SizedBox(height: 15,),
          /// ===== CR =====
          Row(
            children: [
              Text("-> Consistency Ratio (CR) = ${r.cr.toStringAsFixed(4)}",style: TextStyle(fontSize: 17),),
              const SizedBox(width: 10,),
              Text("(Ma trận nhất quán — hợp lệ để dùng trong DSS)",style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)
            ],
          ),
          /// ===== BƯỚC 6 =====
          _title(" — Độ ưu tiên của các phương án theo từng tiêu chí. "),
          _title("Ma trận so sánh theo từng tiêu chí"),
          ...r.matrices
              .where((m) => m['criteriaName'] != "Criteria") // chỉ lấy ma trận tên Criteria
              .map<Widget>((m) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m['criteriaName'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildMatrix(m['matrix']),
              ],
            );
          }).toList(),
          ///trong so
          _title("Ma trận trọng sô theo từng tiêu chí"),
          ...r.alternativeWeights.map<Widget>((a) {
            List weights = a['weights'];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a['criteriaName'],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                buildTable(
                  headers: ["Phương án", "Trọng số"],
                  data: List<List<dynamic>>.generate(
                    weights.length,
                        (i) => [
                      "A${i + 1}",
                      (weights[i] as num).toStringAsFixed(3)
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
          /// ===== KẾT QUẢ =====
          _title("Kết quả cuối"),
          buildTable(
            headers: ["Phương án", "Trọng số"],
            data: List<List<dynamic>>.generate(
              r.finalScores.length,
                  (i) => [
                "A${i + 1}",
                (r.finalScores[i] as num).toStringAsFixed(3)
              ],
            ),
          ),
          /// ===== BEST =====
          _title("Kết luận"),
          _bestCard(r.best),
          const SizedBox(height: 20,),
         Container(
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(12),
             color: Colors.green.shade800
           ),
           width: 400,
           child: Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text("A1 : Cảnh báo ngay, hỗ trợ học tập", style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold),),
                 Text("A2 : Nhắc nhở, theo dõi thêm", style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
                 Text("A3 : Không cần cảnh báo, tiếp tục theo dõi", style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold))
               ],
             ),
           ),
         )
        ],
      ),
    );
  }

  /// ===== TITLE =====
  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// ===== BEST CARD =====
  Widget _bestCard(String best) {
    return Card(
      color: Colors.green.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            best,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
        ),
      ),
    );
  }

  /// ===== TABLE CHUNG =====
  Widget buildTable({
    required List<String> headers,
    required List<List<dynamic>> data,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(color: Colors.black54),
        defaultColumnWidth: FixedColumnWidth(170),
        children: [
          /// HEADER
          TableRow(
            decoration: BoxDecoration(
                color: Colors.blue.shade800),
            children: headers
                .map((h) => _cell(h, isHeader: true))
                .toList(),
          ),

          /// DATA
          ...data.map((row) {
            return TableRow(
              children: row.map((cell) {
                return _cell(cell.toString());
              }).toList(),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// ===== FIX MATRIX TYPE 100% =====
  Widget _buildMatrix(dynamic matrix) {
    List<List<dynamic>> data =
    (matrix as List).map((row) => List<dynamic>.from(row)).toList();

    return buildTable(
      headers: List.generate(data[0].length, (i) => "C${i + 1}"),
      data: data,
    );
  }

  /// ===== CELL =====
  Widget _cell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}