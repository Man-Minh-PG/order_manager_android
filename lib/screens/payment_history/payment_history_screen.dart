import 'package:flutter/material.dart';
import 'package:grocery_app/provider/order_service.dart';
import 'package:grocery_app/screens/payment_history/create_transaction_payment.dart';

class PaymentHistoryScreen extends StatefulWidget {
  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final OrderService orderService = OrderService();
  final isExpenses = 0;
  final isRevenue = 1;

  List<Map<String, dynamic>> listHistory = [];
  List<Map<String, dynamic>> dataInitialCost = [];
  Map<String, dynamic> conditionInitialCost = {
      'generic.name': 'initialCost',
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  
  Future<void> fetchOrders() async {
    listHistory = await orderService.getDataWithCondition('transaction_history');
    dataInitialCost = await orderService.getDataWithCondition('generic', conditions: conditionInitialCost);
    
    // Convert listHistory to a mutable list if it is read-only
    listHistory = List<Map<String, dynamic>>.from(listHistory); // solution fix : read only

    if(dataInitialCost.isNotEmpty) {
      for (int i = 0; i < dataInitialCost.length ; i++) {
        Map<String, dynamic> newEntry = {
          'id' : 0,
          'value_payment' : int.parse(dataInitialCost[i]['value']),
          'type' : 1,
          'note' : 'Tiền đầu giờ',
          'createdAt' : dataInitialCost[i]['createdAt'],
        };

        listHistory.add(newEntry);
      }
    }
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
      : Expanded(
        child: ListView.builder(
          // physics: NeverScrollableScrollPhysics(), // fix lag scroll bar
          itemCount: listHistory.length, // temp 
          itemBuilder: (BuildContext context, int index) {
            return orderItem();
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // _showInputUpdateInitialCost(context);
        
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateTransactionPayment()),
    );
        },
        backgroundColor: Color(0xFF897CEE),
        child: Icon(Icons.attach_money_sharp),
      ),
    ); 
  }

  Widget orderItem() {
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
                        text: "${listHistory[0]['id']}",
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
                    "${listHistory[0]['createdAt'] ?? ''}",
                    style: TextStyle(color: const Color.fromARGB(255, 54, 54, 54)),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text("${listHistory[0]['note'] ?? ''}"),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${listHistory[0]['value_payment'] ?? ''}K",
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
                      color:  listHistory[0]['type'] == isExpenses ? Colors.orange.withOpacity(0.2) : Color(0xFF897CEE).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: listHistory[0]['type'] == isExpenses ? Border.all(color: Colors.orange) : Border.all(color: Color(0xFF897CEE)),
                    ),
                    child: 
                    listHistory[0]['type'] == isExpenses ?
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

  /**
   * Function show dialog insert initial cost
   */
  Future<void> _showInputUpdateInitialCost(BuildContext context) async { 
    TextEditingController _initialCostController = TextEditingController();
    int? _selectedTag = 1;

    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tổng tiền hom nay'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _initialCostController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "600"),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 5.0,
                children: List<Widget>.generate(
                  3,
                  (int index) {
                    return ChoiceChip(
                      label: Text('Item $index'),
                      selected: _selectedTag == index,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedTag = selected ? index : null;
                        });
                      },
                    );
                  },
                ).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text('close')
            ),
            TextButton(
              onPressed: () async {
                String initialCostValue = _initialCostController.text;
                int resultUpdate = await orderService.updateGenericData(initialCostValue ,'initialCost');

                if(resultUpdate < 0) {
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
                    )
                  );
                }

                 Navigator.of(context).pop();
              }, 
              child: Text('Save') 
            )            
          ],
        );
      } 
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