import 'package:flutter/material.dart';
import 'package:grocery_app/models/daily_report_model.dart';
import 'package:grocery_app/provider/report_service.dart';
import 'package:grocery_app/helpers/database.dart';
import 'package:sqflite/sqflite.dart';

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

  Future<void> loadData() async {
    report = await _reportService.getDailyReport();

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

    setState(() => isLoading = false);
  }

    /// ✅ FIX: insert hoặc update luôn
  Future<void> updateCashIfChanged(int value) async {
    if (lastSavedCash == value) return;

    final db = await _dbRepo.database;

    await db.insert(
      'generic',
      {
        'name': 'actualCash',
        'value': value.toString(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    lastSavedCash = value;

    report = await _reportService.getDailyReport();
    setState(() {});
  }

  String formatCurrency(int number) {
    final amount = number * 1000;
    final str = amount.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return '$str ₫';
  }

  int get actualCash => int.tryParse(cashController.text) ?? 0;
  int get systemCash => report?.totalCash ?? 0;
  int get systemBank => report?.totalBank ?? 0;

  int get diff => actualCash - systemCash;

  /// 🔥 BOX PHÂN TÍCH
  Widget _analysisBox() {
    if (report == null) return const SizedBox();

    /// ✅ KHỚP TIỀN
    if (diff == 0) {
      return _infoBox(
        color: Colors.green,
        icon: Icons.check_circle,
        title: "Tiền đã khớp",
        message: "Số tiền thực tế trùng với hệ thống 👍",
      );
    }

    final isMissing = diff < 0;

    /// ❌ THIẾU TIỀN
    if (isMissing) {
      final missingBuns = report!.missingProduct.floor(); // làm tròn xuống
      String message =
          "Thiếu ${formatCurrency(diff.abs())} (~$missingBuns bánh)";

      String sub = "";

      /// 🔥 PHÂN TÍCH THÔNG MINH
      if (systemBank == 0) {
        sub = "Có khả năng đơn chuyển khoản bị nhập nhầm thành tiền mặt";
      } else {
        sub = "Kiểm tra lại tiền mặt hoặc có thể thất thoát tiền/bánh";
      }

      return _infoBox(
        color: Colors.red,
        icon: Icons.warning_amber,
        title: message,
        message: sub,
      );
    }

    /// ⚠️ DƯ TIỀN
    return _infoBox(
      color: Colors.orange,
      icon: Icons.info_outline,
      title: "Dư ${formatCurrency(diff)}",
      message: "Có thể nhập dư tiền hoặc ghi nhận sai đơn hàng",
    );
  }

  Widget _infoBox({
    required Color color,
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
        title: const Text("Phân tích"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                /// 💰 DOANH THU
                _section("Doanh thu", [
                  _row("Tổng doanh thu", formatCurrency(report?.totalRevenue ?? 0)),
                  _row("Tiền mặt (hệ thống)", formatCurrency(systemCash)),
                  _row("Chuyển khoản (hệ thống)", formatCurrency(systemBank)),
                ]),

                const Divider(),

                /// 💵 KIỂM TIỀN
                _section("Tiền thực tế", [
                  TextField(
                    controller: cashController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Nhập tiền mặt thực tế",
                      suffixText: "₫",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      if (RegExp(r'^\d*$').hasMatch(value)) {
                        int v = int.tryParse(value) ?? 0;
                        updateCashIfChanged(v);
                      } else {
                        cashController.text =
                            value.replaceAll(RegExp(r'\D'), '');
                        cashController.selection =
                            TextSelection.fromPosition(
                          TextPosition(offset: cashController.text.length),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 10),

                  _row("Tiền mặt (thực tế)", formatCurrency(actualCash)),
                  _row("Tiền ngân hàng (ước tính)", formatCurrency((report?.totalRevenue ?? 0) - actualCash)),

                  _row(
                    "Chênh lệch",
                    formatCurrency(diff),
                    color: diff == 0
                        ? Colors.green
                        : (diff < 0 ? Colors.red : Colors.orange),
                  ),

                  _analysisBox(),
                ]),

                const Divider(),

                /// 📦 SẢN PHẨM
                _section("Sản phẩm", [
                  _row("Tổng nhập", report?.totalProduct.toString() ?? "0"),
                  _row("Đã bán", report?.totalSold.toString() ?? "0"),
                  _row("Tồn kho (lý thuyết)", report?.theoreticalStock.toString() ?? "0"),
                ]),

                const SizedBox(height: 20),
              ],
            ),
    );
  }
}