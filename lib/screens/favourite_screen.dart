import 'package:flutter/material.dart';
import 'package:grocery_app/provider/order_service.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
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
    setState(() {});
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
    );
  }
}
