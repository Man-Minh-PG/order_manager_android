import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/more/create_transaction_screen.dart';
import 'package:grocery_app/screens/more/product_management_screen.dart';
import 'package:grocery_app/screens/more/check_bill_screen.dart';
import 'package:grocery_app/helpers/database.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final DatabaseRepository _databaseRepository = DatabaseRepository.instance;
  bool _isLoading = false;

  Widget _buildItem(BuildContext context, IconData icon, String title, Widget screen) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepOrange),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        },
      ),
    );
  }

  Widget _buildResetButton(BuildContext context) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.restart_alt, color: Colors.red),
        title: const Text(
          "Reset dữ liệu",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
        ),
        subtitle: const Text("Khôi phục hệ thống"),
        onTap: () => _confirmReset(context),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc muốn xóa toàn bộ dữ liệu không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      _handleReset(context);
    }
  }

  Future<void> _handleReset(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      final db = await _databaseRepository.deleteOldDatabase();
      setState(() => _isLoading = false);

      if (db == true) {
        await _databaseRepository.database;

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Notification'),
            content: const Text('Xóa thành công'),
            actions: [
              TextButton(
                onPressed: () {
                  exit(0);
                },
                child: const Text('Đóng'),
              ),
            ],
          ),
        );
      } else {
        _showError(context);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError(context);
    }
  }

  void _showError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification'),
        content: const Text('Có lỗi xảy ra khi xóa đơn hàng - vui lòng thử lại sau.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("More"),
            centerTitle: true,
            automaticallyImplyLeading: false, // Ẩn nút back
          ),
          body: ListView(
            children: [
              _buildItem(context, Icons.add_circle_outline, "Add Bill", CreateTransactionScreen()),
              _buildItem(context, Icons.inventory_2_outlined, "Bachutha edit", ProductManagementScreen()),
              _buildItem(context,Icons.receipt_long,"Check Bill", CheckBillScreen()),
              _buildResetButton(context), 
            ],
          ),
        ),

        // 🔥 Loading overlay
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.4),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}    