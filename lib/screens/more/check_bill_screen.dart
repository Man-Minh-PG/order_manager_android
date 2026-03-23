import 'package:flutter/material.dart';
import 'package:grocery_app/models/daily_report_model.dart';
import 'package:grocery_app/provider/report_service.dart';
import 'package:grocery_app/helpers/database.dart';

class CheckBillScreen extends StatefulWidget {
  const CheckBillScreen({super.key});

  @override
  State<CheckBillScreen> createState() => _CheckBillScreenState();
}

class _CheckBillScreenState extends State<CheckBillScreen> {
  final ReportService _reportService = ReportService();
  final DatabaseRepository _dbRepo = DatabaseRepository.instance;

  DailyReport? report;
  bool isLoading = true;

  final TextEditingController cashController = TextEditingController();
  int? lastSavedCash;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  /// Load dữ liệu từ DB và report
  Future<void> loadData() async {
    report = await _reportService.getDailyReport();

    // Load actualCash từ generic
    final db = await _dbRepo.database;
    final result = await db.query(
      'generic',
      where: 'name = ?',
      whereArgs: ['actualCash'],
    );

    int actualCash = report!.actualCash;
    if (result.isNotEmpty) {
      actualCash = int.tryParse(result.first['value'].toString()) ?? actualCash;
    }

    cashController.text = actualCash.toString();
    lastSavedCash = actualCash;

    setState(() {
      isLoading = false;
    });
  }

  /// Update giá trị actualCash nếu có thay đổi
  Future<void> updateCashIfChanged(int value) async {
    if (lastSavedCash == value) return;

    final db = await _dbRepo.database;
    await db.update(
      'generic',
      {'value': value.toString()},
      where: 'name = ?',
      whereArgs: ['actualCash'],
    );

    lastSavedCash = value;

    // reload report để update bank / diff
    report = await _reportService.getDailyReport();
    setState(() {});
  }

  /// Hàm format số thành tiền (number * 1000 -> "30.000 ₫")
  String formatCurrency(int number) {
    final amount = number * 1000;
    final str = amount.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    return '$str ₫';
  }

  int get actualCash => int.tryParse(cashController.text) ?? 0;
  int get bankMoney => (report?.totalRevenue ?? 0) - actualCash;
  int get diff => actualCash - (report?.totalCash ?? 0);

  Widget _row(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Bill"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                /// 💰 DOANH THU
                _section("Doanh thu", [
                  _row("Tổng", formatCurrency(report?.totalRevenue ?? 0)),
                  _row("Tiền mặt", formatCurrency(report?.totalCash ?? 0)),
                  _row("Chuyển khoản", formatCurrency(report?.totalBank ?? 0)),
                ]),

                const Divider(),

                /// 💵 KIỂM TIỀN
                _section("Kiểm kê tiền", [
                  TextField(
                    controller: cashController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Tiền mặt thực tế (nghìn ₫)",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // chỉ cho nhập số nguyên
                      if (RegExp(r'^\d*$').hasMatch(value)) {
                        int v = int.tryParse(value) ?? 0;
                        updateCashIfChanged(v);
                      } else {
                        // remove ký tự không phải số
                        cashController.text = value.replaceAll(RegExp(r'\D'), '');
                        cashController.selection = TextSelection.fromPosition(
                          TextPosition(offset: cashController.text.length),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 10),

                  _row("Tiền ngân hàng", formatCurrency(bankMoney)),

                  _row(
                    "Chênh lệch",
                    formatCurrency(diff),
                    color: diff == 0
                        ? Colors.green
                        : (diff < 0 ? Colors.red : Colors.orange),
                  ),
                ]),

                const Divider(),

                /// 📦 SẢN PHẨM
                _section("Sản phẩm", [
                  _row("Tổng", report?.totalProduct.toString() ?? "0"),
                  _row("Đã bán", report?.totalSold.toString() ?? "0"),
                  _row("Tồn kho", report?.theoreticalStock.toString() ?? "0"),
                ]),

                const SizedBox(height: 20),
              ],
            ),
    );
  }
}