import 'package:flutter/material.dart';
import 'package:grocery_app/provider/order_service.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final OrderService orderService = OrderService();
  final int cashPayment = 1;
  final int momoPayment = 2;
  final int transferPayment = 3;
  final int noPayment = 0;
  bool _isLoading = true; // Mặc định đang tải dữ liệu
  int optionFilter = 0; // 0 là tất cả, 1 là thanh toán bằng tiền mặt, 2 là thanh toán bằng momo, 3 là chuyển khoản
  final int orderStatusDefault = 0;
  final int orderStatusSucess = 1;
  
  Map<int, List<Map<String, dynamic>>> groupedOrders = {};
  Map<int, List<Map<String, dynamic>>> tempData = {};
  List<Map<String, dynamic>> orders = [];

  List<String> paymentMethods = ['Tiền mặt', 'Momo', 'Chuyển khoản']; // Danh sách phương thức thanh toán



  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    orders = await orderService.selectOrdersWithStatus1();
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
      tempData = Map.from(groupedOrders); // Lưu trạng thái ban đầu vào tempData
    });

    setState(() {
      _isLoading = false; // load xong
    });
  }

  void filterOrders(int optionFill) {
    setState(() {
      if (optionFill == 0) {
        groupedOrders = Map.from(tempData); // Khôi phục dữ liệu ban đầu
      } else {
        groupedOrders.clear();
        for (var order in orders) {
          if (order['productId'] == optionFill) {
            int orderId = order['orderId'];
            if (!groupedOrders.containsKey(orderId)) {
              groupedOrders[orderId] = [order];
            } else {
              groupedOrders[orderId]!.add(order);
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History order'), // Tiêu đề của AppBar
        // Các thuộc tính khác của AppBar như backgroundColor, actions, v.v...
      ),
      body: _isLoading 
      ? Center(child: CircularProgressIndicator()) // Hiển thị loader khi đang tải dữ liệu 
      : Column(
        children: [
           DropdownButton<int>(
            value: optionFilter,
            items: [
              DropdownMenuItem<int>(
                value: 0,
                child: Text('Tất cả'),
              ),
              DropdownMenuItem<int>(
                value: 14,
                child: Text('Now'),
              ),
              DropdownMenuItem<int>(
                value: 15,
                child: Text('Grap'),
              ),
              DropdownMenuItem<int>(
                value: 16,
                child: Text('Go'),
              ),
              DropdownMenuItem<int>(
                value: 17,
                child: Text('Bee'),
              ),
            ],
            onChanged: (int? value) {
              if (value != null) {
                filterOrders(value);
              }
            },
          ),

           Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: groupedOrders.length,
                    itemBuilder: (BuildContext context, int index) {
                      int orderId = groupedOrders.keys.elementAt(index);
                      List<Map<String, dynamic>> products = groupedOrders[orderId]!;
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
                                      Text("Order ID: $orderId", style: TextStyle(color: Colors.green)),
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
                                              DropdownMenuItem<int>(
                                                value: noPayment,
                                                child: Text('Chưa TToán'),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                products[0]['paymentMethod'] = value; // Cập nhật giá trị paymentMethod cho đơn hàng cụ thể 
                                              });
                                            
                                              _handlePayment(context, products[0]['orderId'], value!, 0, orderStatusSucess);
                                            },
                                          ),
                                         
                                        ],
                                      ),
                                    ],
                                  )]),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Total Amount: $totalAmount", style: TextStyle(color: Colors.orangeAccent)),
                                  SizedBox(height: 8),
                                  Text("payment: ${products[0]['paymentName'] ?? ''}", style: TextStyle(color: Colors.blue)),
                                  SizedBox(height: 8),
                                  Text("Status: ${products[0]['orderStatus'] == 1 ? 'Thành công' : 'Hủy đơn'}", style: TextStyle(color: Color.fromARGB(255, 23, 150, 31))),
                                   SizedBox(height: 8),
                                  Text("Note: ${products[0]['note']}")
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
                                Text("Time: ${products[0]['createdAt'] ?? ''}", style: TextStyle(color: Colors.blue)),
                              ]
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                  ),
                  ),
          ),
        ],
      ) 
      
    );

    
  }

    // Function để xử lý sự kiện khi người dùng thay đổi phương thức thanh toán
  Future<void> _handlePayment(BuildContext context, int orderId, int paymentMethod, int removeShow, int statusOrder) async {

      // Hiển thị cửa sổ xác nhận
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Notification"),
              content: Text("Bạn có chắc chắn muốn đổi phương thức thanh toán?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    // Đóng cửa sổ xác nhận
                    Navigator.of(context).pop();
                    
                    // Thực hiện thay đổi phương thức thanh toán 
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
                  },
                  child: Text("Yes"),
                ),
                TextButton(
                  onPressed: () {
                    // Đóng cửa sổ xác nhận
                    Navigator.of(context).pop();
                  
                  },
                  child: Text("No"),
                ),
              ],
            );
          },
        );
  }
}


