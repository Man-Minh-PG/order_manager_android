

import 'package:flutter/material.dart';

import 'package:grocery_app/provider/order_service.dart';
import 'package:grocery_app/helpers/database.dart';
import 'dashboard/dashboard_screen.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final DatabaseRepository _databaseRepository = DatabaseRepository.instance;
  final OrderService orderService = OrderService();

  int? totalProductsSold;
  int? totalRevenue;
  int? totalCancelledOrders;
  int? totalCashPayment;
  int? totalMomoPayment;
  int? totalTransferPayment;
  Map<String, int>? productSales;

  @override
  void initState() {
    super.initState();
    fetchDailySummary();
  }

  Future<void> fetchDailySummary() async {
    totalProductsSold = await orderService.getTotalProductsSoldToday();
    totalRevenue = await orderService.getTotalRevenueToday();
    totalCancelledOrders = await orderService.getTotalCancelledOrdersToday();
    totalCashPayment = await orderService.getTotalPaymentToday('Tien_mat');
    totalMomoPayment = await orderService.getTotalPaymentToday('Momo');
    totalTransferPayment = await orderService.getTotalPaymentToday('Chuyen_Khoan');
    productSales = await orderService.getProductSalesToday();
   setState(() {
     
   });
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tổng kết doanh thu hôm nay'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ngày hôm nay: ${DateTime.now().toString().substring(0, 10)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Tổng số sản phẩm bán được: ${totalProductsSold ?? 0}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Tổng doanh thu: ${totalRevenue ?? 0}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Tổng số đơn hàng bị hủy: ${totalCancelledOrders ?? 0}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Tổng số tiền mặt: ${totalCashPayment ?? 0}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Tổng số tiền Momo: ${totalMomoPayment ?? 0}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Tổng số tiền chuyển khoản: ${totalTransferPayment ?? 0}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Số lượng bán được theo từng sản phẩm:',
              style: TextStyle(fontSize: 16),
            ),
            // Hiển thị số lượng bán được của từng sản phẩm
            Expanded(
              child: ListView.builder(
                itemCount: productSales?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  String productName = productSales?.keys.elementAt(index) ?? '';
                  int quantitySold = productSales?.values.elementAt(index) ?? 0;
                  return ListTile(
                    title: Text(productName),
                    subtitle: Text('Số lượng: $quantitySold'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _confirmDeleteOrder(context);
        }, 
        child: Icon(Icons.delete)
      ),
    );
    
  }
  Future<void> _confirmDeleteOrder(BuildContext context) async {
  // Hiển thị hộp thoại xác nhận
  bool confirmDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Notification"),
        content: Text("Bạn có chắc chắn muốn xóa đơn hàng này không?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Đóng hộp thoại và trả về giá trị false
            },
            child: Text("Không"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Đóng hộp thoại và trả về giá trị true
            },
            child: Text("Có"),
          ),
        ],
      );
    },
  );

  // Nếu người dùng xác nhận muốn xóa đơn hàng
  if (confirmDelete == true) {
    final db = await _databaseRepository.deleteOldDatabase();
    if (db == true) {
      await _databaseRepository.database;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Notification'),
          content: Text('Xóa thành công'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
              },
              child: Text('Đóng'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Notification'),
          content: Text('Có lỗi xảy ra khi xóa đơn hàng - vui lòng thử lại sau.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                fetchDailySummary();
              },
              child: Text('Đóng'),
            ),
          ],
        ),
      );
    }
  }
}

  }

