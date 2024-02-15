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
  OrderService orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    // Tạo hàm để fetch danh sách đơn hàng
    Future<List<Map<String, dynamic>>> fetchOrders() async {
      return await orderService.selectOrdersWithStatus0();
    }

    // Gọi hàm fetchOrders khi cần thiết, chẳng hạn khi màn hình được build
    // và sử dụng kết quả để cập nhật ListView
    return Scaffold(
      body: SafeArea(child: 
        FutureBuilder<List<Map<String, dynamic>>>(
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
              return ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: orders.length,
              itemBuilder: (BuildContext context, int index) {
                // Xây dựng một item trong danh sách đơn hàng
                // ở đây, bạn có thể sử dụng orders[index] để truy cập vào từng đơn hàng
                // và hiển thị thông tin cần thiết
                return Card(
                  color: Colors.white,
                  elevation: 2, // Giảm độ nâng của Card
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.call),
                        title: Text("${orders[index]['total']}",
                            style: TextStyle(color: Colors.green)),
                        subtitle: Text(
                          "${orders[index]['createdAt']}",
                          style: TextStyle(color: Colors.orangeAccent),
                        ),
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
    )
      ),
    );
  }
}
