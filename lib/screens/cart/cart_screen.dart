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
  // const CartScreen({Key key}) : super(key: key);
  OrderService orderService = OrderService();
  

  @override 
   Widget build(BuildContext context) {
    // Tại đây, bạn có thể gọi hàm và lấy kết quả trả về
    Future<void> fetchOrders() async {
      List<Map<String, dynamic>> orders = await orderService.selectOrdersWithStatus0();
      print(orders); // In ra màn hình console
    }

    // Gọi hàm fetchOrders khi cần thiết, chẳng hạn khi màn hình được build
    fetchOrders();

    final List<String> phoneNumber = <String>[
      '6666677897',
      '7777777777',
      '3498789678',
      '7897989780'
    ];
    final List<String> callType = <String>[
      "Incoming",
      "Outgoing",
      "Incoming",
      "Missed"
    ];
 
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: phoneNumber.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          borderOnForeground: true,
          elevation: 10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.call),
                title: Text("${phoneNumber[index]}",
                    style: TextStyle(color: Colors.green)),
                subtitle: Text(
                  "${callType[index]}",
                  style: TextStyle(color: Colors.orangeAccent),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('Dail'),
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
