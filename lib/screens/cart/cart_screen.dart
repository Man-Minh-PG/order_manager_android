import 'package:flutter/material.dart';
import 'package:grocery_app/provider/order_service.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final OrderService orderService = OrderService();
  final int cashPayment = 1;
  final int momoPayment = 2;
  final int transferPayment = 3;

  Map<int, List<Map<String, dynamic>>> groupedOrders = {};

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    List<Map<String, dynamic>> orders = await orderService.selectOrdersWithStatus0();
    setState(() {
      groupedOrders.clear();
      for (var order in orders) {
        int orderId = order['orderId'];
        if (!groupedOrders.containsKey(orderId)) {
          groupedOrders[orderId] = [order];
        } else {
          groupedOrders[orderId]!.add(order);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: groupedOrders.length,
          itemBuilder: (BuildContext context, int index) {
            List<Map<String, dynamic>> products = groupedOrders.values.elementAt(index);
            int totalAmount = products[0]['total'];
            return Card(
              color: Colors.white,
              elevation: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text("Order ID: ${products[0]['orderId']}", style: TextStyle(color: Colors.green)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Amount: $totalAmount", style: TextStyle(color: Colors.orangeAccent)),
                        SizedBox(height: 8),
                        Text("Note: ${products[0]['note'] ?? ''}", style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text("Name: ${products[index]['product_name']}"),
                        subtitle: Text("Amount: ${products[index]['amount']}"),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: const Text('Tien_Mat'),
                        onPressed: () async {
                          int resultUpdate = await orderService.updateOrderStatus(products[0]['orderId'], 1, cashPayment);
                          if (resultUpdate > 0) {
                            setState(() {
                              groupedOrders.remove(products[0]['orderId']);
                            });
                          }  else {
                            // Nếu không có dữ liệu, bạn có thể hiển thị một thông báo hoặc thực hiện một hành động khác ở đây
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Thông báo'),
                                content: Text('Có lỗi update xải ra - vui lòng lien hệ nhà phát triển - xin lỗi vì sự cố này'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Đóng'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                      TextButton(
                        child: const Text('Momo'),
                       onPressed: () async {
                          int resultUpdate = await orderService.updateOrderStatus(products[0]['orderId'], 1, momoPayment);
                          if (resultUpdate > 0) {
                            setState(() {
                              groupedOrders.remove(products[0]['orderId']);
                            });
                          }  else {
                            // Nếu không có dữ liệu, bạn có thể hiển thị một thông báo hoặc thực hiện một hành động khác ở đây
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Thông báo'),
                                content: Text('Có lỗi update xải ra - vui lòng lien hệ nhà phát triển - xin lỗi vì sự cố này'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Đóng'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        child: const Text('Chuyen_Khoan'),
                         onPressed: () async {
                          int resultUpdate = await orderService.updateOrderStatus(products[0]['orderId'], 1, transferPayment);
                          if (resultUpdate > 0) {
                            setState(() {
                              groupedOrders.remove(products[0]['orderId']);
                            });
                          }  else {
                            // Nếu không có dữ liệu, bạn có thể hiển thị một thông báo hoặc thực hiện một hành động khác ở đây
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Thông báo'),
                                content: Text('Có lỗi update xải ra - vui lòng lien hệ nhà phát triển - xin lỗi vì sự cố này'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Đóng'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ),
      ),
    );
  }
}


