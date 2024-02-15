// import 'package:flutter/material.dart';
// import 'package:grocery_app/common_widgets/app_button.dart';
// import 'package:grocery_app/helpers/column_with_seprator.dart';
// import 'package:grocery_app/models/grocery_item.dart';
// import 'package:grocery_app/widgets/chart_item_widget.dart';

// import 'checkout_bottom_sheet.dart';

// class CartScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 25,
//               ),
//               Text(
//                 "List Order",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Column(
//                 children: getChildrenWithSeperator(
//                   addToLastChild: false,
//                   widgets: demoItems.map((e) {
//                     return Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 25,
//                       ),
//                       width: double.maxFinite,
//                       child: ChartItemWidget(
//                         item: e,
//                       ),
//                     );
//                   }).toList(),
//                   seperator: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 25,
//                     ),
//                     child: Divider(
//                       thickness: 1,
//                     ),
//                   ),
//                 ),
//               ),
//               Divider(
//                 thickness: 1,
//               ),
//               getCheckoutButton(context)
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget getCheckoutButton(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
//       child: AppButton(
//         label: "Go To Check Out",
//         fontWeight: FontWeight.w600,
//         padding: EdgeInsets.symmetric(vertical: 30),
//         trailingWidget: getButtonPriceWidget(),
//         onPressed: () {
//           showBottomSheet(context);
//         },
//       ),
//     );
//   }

//   Widget getButtonPriceWidget() {
//     return Container(
//       padding: EdgeInsets.all(2),
//       decoration: BoxDecoration(
//         color: Color(0xff489E67),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Text(
//         "\$12.96",
//         style: TextStyle(fontWeight: FontWeight.w600),
//       ),
//     );
//   }

//   void showBottomSheet(context) {
//     showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         backgroundColor: Colors.transparent,
//         builder: (BuildContext bc) {
//           return CheckoutBottomSheet();
//         });
//   }
// }

import 'package:flutter/material.dart';
import 'package:grocery_app/provider/order_service.dart';

class CartScreen extends StatelessWidget {
  final OrderService orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    // Tạo hàm để fetch danh sách đơn hàng
    Future<List<Map<String, dynamic>>> fetchOrders() async {
      return orderService.selectOrdersWithStatus0();
    }

    // Gọi hàm fetchOrders khi cần thiết, chẳng hạn khi màn hình được build
    // và sử dụng kết quả để cập nhật ListView
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Nếu đang đợi kết quả, có thể hiển thị một tiêu đề hoặc tiến trình tải
              return Center(child: CircularProgressIndicator());
            } else {
              // Nếu đã có kết quả, hiển thị danh sách các đơn hàng
              if (snapshot.hasError) {
                // Xử lý lỗi nếu có
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                // Hiển thị ListView với số lượng đơn hàng đã fetch về
                List<Map<String, dynamic>> orders = snapshot.data ?? [];
                
                // Tạo danh sách mới để nhóm sản phẩm theo ID đơn hàng
                Map<int, List<Map<String, dynamic>>> groupedOrders = {};

                // Nhóm sản phẩm theo ID đơn hàng
                for (var order in orders) {
                  int orderId = order['orderId'];
                  if (!groupedOrders.containsKey(orderId)) {
                    groupedOrders[orderId] = [order];
                  } else {
                    groupedOrders[orderId]!.add(order);
                  }
                }

                  return ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: groupedOrders.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Lấy danh sách sản phẩm của một đơn hàng
                    List<Map<String, dynamic>> products = groupedOrders.values.elementAt(index);

                    // Lấy giá trị total của đơn hàng từ cơ sở dữ liệu
                    int totalAmount = products[0]['total'];

                    // Hiển thị thông tin của đơn hàng
                    return Card(
                    color: Colors.white,
                    elevation: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.shopping_cart),
                          title: Text("Order ID: ${products[0]['orderId']}",
                            style: TextStyle(color: Colors.green)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Amount: $totalAmount",
                                style: TextStyle(color: Colors.orangeAccent),
                              ),
                              SizedBox(height: 8),
                              Text("Note: ${products[0]['note'] ?? ''}",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                        // Hiển thị danh sách sản phẩm trong đơn hàng
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: products.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text("Product ID: ${products[index]['productId']}"),
                              subtitle: Text("Amount: ${products[index]['amount']}"),
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              child: const Text('Dial'),
                              onPressed: () {/* ... */},
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              child: const Text('Call History'),
                              onPressed: () {/* ... */},
                            ),
                          ],
                        ),
                      ],
                    ),
                  );

                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                );

              }
            }
          },
        ),
      ),
    );
  }
}
