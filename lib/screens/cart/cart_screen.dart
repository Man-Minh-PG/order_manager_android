import 'package:flutter/material.dart';
import 'package:grocery_app/provider/order_service.dart';
import 'package:grocery_app/screens/cart/edit_order_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final OrderService orderService = OrderService();
  final int cashPayment = 1;
  final int momoPayment = 2;
  final int transferPayment = 3;
  final int orderStatusDefault = 0;
  final int orderStatusSucess = 1;

  bool _isLoading = true; // Mặc định đang tải dữ liệu

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
          groupedOrders[orderId] = [order].toList(); // Chuyển danh sách sang một danh sách có thể sửa đổi
          // groupedOrders[orderId]['paymentMethod'] = cashPayment; // Gán giá trị cho phần tử đó
        } else {
          groupedOrders[orderId]!.add(order);
        }
      }
    });

    setState(() {
      _isLoading = false; // load xong
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List order'), // Tiêu đề của AppBar
        // Các thuộc tính khác của AppBar như backgroundColor, actions, v.v...
      ),
      body: _isLoading
       ? Center(child: CircularProgressIndicator()) // Hiển thị loader khi đang tải dữ liệu 
       : SafeArea(
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
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Mã đơn hàng: ${products[0]['orderId']}", style: TextStyle(color: Colors.green)),
                           
                          ],
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tổng: $totalAmount K", style: TextStyle(color: Colors.orangeAccent, fontSize: 16)),
                        SizedBox(height: 8),
                        Text("Ghi chú: ${products[0]['note'] ?? ''}", style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text("Tên sản phẩm: ${products[index]['product_name']}"),
                        subtitle: Text("Số lượng: ${products[index]['amount']}"),
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () =>   _handlePayment(context, products[0]['orderId'], products[0]['orderId']!, 1, orderStatusSucess),
                    child: const Text('Finish'),
                  ),
                   ButtonBar(
                              alignment: MainAxisAlignment.end,
                              children: [
                                DropdownButton<int?>(
                                  value: products[0]['paymentMethod'], // Giá trị mặc định (tiền mặt)
                                  items: [
                                    DropdownMenuItem<int>(
                                      value: cashPayment,
                                      child: Text('Tiền mặt'),
                                    ),
                                    DropdownMenuItem<int>(
                                      value: momoPayment,
                                      child: Text('Momo'),
                                    ),
                                    DropdownMenuItem<int>(
                                      value: transferPayment,
                                      child: Text('Chuyển khoản'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                       products[0]['paymentMethod'] = value; // Cập nhật giá trị paymentMethod cho đơn hàng cụ thể 
                                    });
                                   
                                     _handlePayment(context, products[0]['orderId'], value!, 0, orderStatusDefault);
                                  },
                                ),
                                IconButton(
                                  onPressed: () => _confirmDeleteOrder(context, products[0]['orderId']),
                                  icon: const Icon(Icons.highlight_remove),
                                ),
                                IconButton(
                                  onPressed: () => _editOrder(context, products[0]['orderId']),
                                  icon: const Icon(Icons.mode_edit),
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

  Future<void> _handleFinish(BuildContext context, int orderId, int paymentMethod) async {
    // Xử lý khi nhấn nút Finish
    print('Order ID: $orderId - Payment Method: $paymentMethod');
    // Thực hiện các thao tác cần thiết sau khi nhấn Finish
  }

  Future<void> _handlePayment(BuildContext context, int orderId, int paymentMethod, int removeShow, int statusOrder) async {
    int resultUpdate = await orderService.updateOrderStatus(orderId, statusOrder, paymentMethod);
    if (resultUpdate > 0) {
      if( removeShow == 1) {
        setState(() {
                groupedOrders.remove(orderId);
              });
      }
      
    } else {
      // Hiển thị hộp thoại thông báo lỗi
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Notification'),
          content: Text('Có lỗi xảy ra khi cập nhật đơn hàng - vui lòng thử lại sau.'),
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
  }

  Future<void> _confirmDeleteOrder(BuildContext context, int orderId) async {
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
      int resultUpdate = await orderService.updateOrderStatus(orderId, 2, cashPayment);
      if (resultUpdate > 0) {
        setState(() {
          groupedOrders.remove(orderId);
        });
      } else {
        // Hiển thị hộp thoại thông báo lỗi
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Notification'),
            content: Text('Có lỗi xảy ra khi xóa đơn hàng - vui lòng thử lại sau.'),
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
    }
  }

  void _editOrder(BuildContext context, int orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditOrderScreen(orderId: orderId)),
    );
  }
}
