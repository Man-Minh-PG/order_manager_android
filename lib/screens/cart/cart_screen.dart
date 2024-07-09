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
  final int noPayment = 0;
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
        automaticallyImplyLeading: false, // fix button back - edit order
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
                            Text("Num ID: # ${products[0]['orderId']}", style: TextStyle(color: Color.fromARGB(255, 86, 90, 90), fontWeight: FontWeight.bold, fontSize: 15)),
                            // SizedBox(height: 1),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Total: ',
                                    style: TextStyle(color: Colors.black, fontSize: 16),
                                  ),
                                  TextSpan(
                                    text: ' $totalAmount K',
                                    style: TextStyle(color: Color.fromARGB(255, 248, 66, 42), fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [       
                        // SizedBox(height: 5),
                        Text("Ghi chú: ${products[0]['note'] ?? ''}", style: TextStyle(color: const Color.fromARGB(255, 243, 33, 114))),
                      ],
                    ),
                  ),

                  // Divider( // Thêm Divider để phân chia ListTile và phần còn lại của Card
                  //   color: Colors.grey, // Màu của đường gạch
                  //   thickness: 0.5, // Độ dày của đường gạch
                  //   height: 0, // Chiều cao của đường gạch
                  // ),
                  
                  ListView.builder(
                    padding: EdgeInsets.zero, // Không có padding
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      // return ListTile(
                      //   dense: true, // Sử dụng dense để làm cho ListTile gọn hơn
                      //   // contentPadding: EdgeInsets.symmetric(vertical: 0), // Giảm padding bên trong ListTile - padding hướng ngang á
                      //   title: Text(
                      //     "Tên sản phẩm: ${products[index]['product_name']} - Số lượng: ${products[index]['amount']}",
                      //     style: TextStyle(fontSize: 13),
                      //   ),
                      //   // subtitle: Text("Số lượng: ${products[index]['amount']}",
                      //   //   style: TextStyle(fontSize: 13)
                      //   // ),
                      // );     
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${products[index]['product_name']}"),
                            Text("Số lượng: ${products[index]['amount']}"),
                          ],
                        ),
                      );
                    },
                  ),
                  
                  ElevatedButton(
                  onPressed: () {
                    if (products.isNotEmpty && products[0]['paymentMethod'] == noPayment) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Notification'),
                          content: Text('Phải thanh toán trước khi hoàn thành đơn.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              }, 
                              child: Text('Close')
                            )
                          ],
                        )
                      );
                    } else {
                      if (products.isNotEmpty) {
                        _handlePayment(context, products[0]['orderId'], products[0]['paymentMethod']!, 1, orderStatusSucess);
                      }
                    }
                  },
                  child: const Text('Finish'),
                ),
                  
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 0.5
                          )
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: products.isNotEmpty ? (products[0]['isDiscount'] == 1) ? true : false : false,
                              onChanged: (value) {
                                if(value == true) {
                                  setState(() {
                                    products[0]['isDiscount'] = 1; // update state
                                    products[0]['discountDetail'] = (totalAmount * 0.3).toInt();  // update discount detail
                                    totalAmount = totalAmount - (totalAmount * 0.3).toInt(); 
                                    products[0]['total'] = totalAmount; // update total in UI
                                  });

                                  _handleDiscount(context, products[0]['orderId'], products[0]['total']);
                                }else {
                                  setState(() {
                                    products[0]['isDiscount'] = 0; // update state
                                    int discountDetail = products[0]['discountDetail'];
                                    totalAmount = totalAmount + discountDetail; 
                                    products[0]['total'] = totalAmount; // update total in UI

                                    products[0]['discountDetail'] = 0;// update discount detail
                                  });

                                  _handleDiscount(context, products[0]['orderId'], products[0]['total']);
                                }
                              },                        
                            ),
                            Icon(Icons.discount_sharp),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
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
                                      child: Text('Bank'),
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

                   
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ),
      ),
    );
  }

  /**
   * Process update total in order 
   * Discount 30%
   */
  Future<void> _handleDiscount(BuildContext context, int orderId, int totalDiscount) async {
    int resultUpdate = await orderService.updateDiscountInOrder(orderId, totalDiscount);

    if(resultUpdate < 0)  {
       showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Notification'),
          content: Text('Error Update Fail !!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('close'),
            ),
          ],
        ));
    }

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
          content: Text('Có lỗi xảy ra - vui lòng thử lại sau.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('close'),
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
