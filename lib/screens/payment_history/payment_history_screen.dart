import 'package:flutter/material.dart';
import 'package:grocery_app/models/generic.dart';
import 'package:grocery_app/provider/order_service.dart';
import 'package:grocery_app/screens/payment_history/create_transaction_payment.dart';

class PaymentHistoryScreen extends StatefulWidget {
  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final OrderService orderService = OrderService();

  List<Map<String, dynamic>> listHistory = [];
  // List<Map<String, dynamic>> dataInitialCost = [];
  // Map<String, dynamic> conditionInitialCost = {
  //     'generic.name': 'initialCost',
  // };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  
  Future<void> fetchOrders() async {
    listHistory = await orderService.getDataWithCondition('transaction_history');
    // dataInitialCost = await orderService.getDataWithCondition('generic', conditions: conditionInitialCost);
    
    // Convert listHistory to a mutable list if it is read-only
    listHistory = List<Map<String, dynamic>>.from(listHistory); // solution fix : read only

    // if(dataInitialCost.isNotEmpty) {
    //   for (int i = 0; i < dataInitialCost.length ; i++) {
    //     Map<String, dynamic> newEntry = {
    //       'id' : 0,
    //       'value_payment' : int.parse(dataInitialCost[i]['value']),
    //       'type' : "Chi",
    //       'note' : "Tiền đầu giờ",
    //       'createdAt' : dataInitialCost[i]['createdAt'],
    //     };

    //     listHistory.add(newEntry);
    //   }
    // } // update required -- when insert generic -> add transaction_history
    // 
    // listHistory.addAll(dataInitialCost);
    // temp
    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('History transaction'),
      ),
      body: _isLoading
      ? Center(child: CircularProgressIndicator(),)
      // : Expanded(  // bug Exception caught by widgets library - Incorrect use of ParentDataWidget.
      //   child: ListView.builder( // auto reponsize 
      //     // physics: NeverScrollableScrollPhysics(), // fix lag scroll bar
      //     itemCount: listHistory.length, // temp 
      //     itemBuilder: (BuildContext context, int index) {
      //       return orderItem(index);
      //     }
      //   ),
      // ),
      : 
        ListView.builder( // auto reponsize 
          // physics: NeverScrollableScrollPhysics(), // fix lag scroll bar
          itemCount: listHistory.length, // temp 
          itemBuilder: (BuildContext context, int index) {
            return orderItem(index);
          },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // _showInputUpdateInitialCost(context);
        
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => CreateTransactionPayment()),
          // );
          _navigateToScreenCreateTransaction();
        },
        // backgroundColor: Color(0xFF897CEE),
        backgroundColor: Color.fromARGB(255, 240, 70, 28),
        child: Icon(
          Icons.post_add_sharp,
          color: const Color.fromARGB(255, 233, 233, 43),        
        ),
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    ); 
  }

  Future<void> _navigateToScreenCreateTransaction() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateTransactionPayment()),
    );

    if (result == true) {
      // Fetch lại dữ liệu nếu có kết quả trả về từ màn hình B
      fetchOrders();
    }
  }

  Widget orderItem(int index) {
      return Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
           side: BorderSide(color: Colors.grey[300]!), // Use 'side' to set the border color  
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Transaction #: ',
                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "${listHistory[index]['id']}",
                        style: TextStyle(color: Color(0xFF897CEE), fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  // Text(
                  //   "Transaction #: ${listHistory[0]['id']}",
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.blue,
                  //   ),
                  // ),
                  SizedBox(height: 8),
                  Text(
                    "${listHistory[index]['createdAt'] ?? ''}",
                    style: TextStyle(color: const Color.fromARGB(255, 54, 54, 54)),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text("${listHistory[index]['note'] ?? ''}"),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${listHistory[index]['value_payment'] ?? ''}K",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color:  listHistory[index]['type'] == Generic.isExpenses ? Colors.orange.withOpacity(0.2) : Color(0xFF897CEE).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: listHistory[index]['type'] == Generic.isExpenses ? Border.all(color: Colors.orange) : Border.all(color: Color(0xFF897CEE)),
                    ),
                    child: 
                    listHistory[index]['type'] == Generic.isExpenses ?
                    Text(
                      'Tiền Chi',
                      style: TextStyle(color: Colors.orange),
                    ):  Text(
                      'Tiền Thu',
                      style: TextStyle(color: const Color(0xFF897CEE), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

  // Convert the widget to a functional widget
    // Widget orderItem() {
    //   return Card(
    //     elevation: 2,
    //     margin: EdgeInsets.symmetric(vertical: 8),
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //     child: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 'Order #: 429242424',
    //                 style: TextStyle(
    //                   fontSize: 16,
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.blue,
    //                 ),
    //               ),
    //               Text(
    //                 'Mon, July 3rd',
    //                 style: TextStyle(color: Colors.grey[600]),
    //               ),
    //               SizedBox(height: 8),
    //               Container(
    //                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    //                 decoration: BoxDecoration(
    //                   color: Colors.grey[200],
    //                   borderRadius: BorderRadius.circular(12),
    //                 ),
    //                 child: Text('2.5 lbs'),
    //               ),
    //             ],
    //           ),
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.end,
    //             children: [
    //               Text(
    //                 '\$1.50',
    //                 style: TextStyle(
    //                   fontSize: 18,
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.black,
    //                 ),
    //               ),
    //               SizedBox(height: 8),
    //               Container(
    //                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    //                 decoration: BoxDecoration(
    //                   color: Colors.orange.withOpacity(0.2),
    //                   borderRadius: BorderRadius.circular(12),
    //                   border: Border.all(color: Colors.orange),
    //                 ),
    //                 child: Text(
    //                   'Accepted',
    //                   style: TextStyle(color: Colors.orange),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }
}