import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_widgets_common.dart';
import 'package:grocery_app/models/generic.dart';
import 'package:grocery_app/provider/app_common_service.dart';

import 'package:grocery_app/provider/order_service.dart';
import 'package:grocery_app/helpers/database.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final DatabaseRepository _databaseRepository = DatabaseRepository.instance;
  final OrderService orderService = OrderService();
  final AppCommonService commonService = AppCommonService();
  bool _isLoading = true; // Mặc định đang tải dữ liệu

  int? totalProductsSold;
  int? totalRevenue;
  int? totalCancelledOrders;
  int? totalCashPayment;
  int? totalMomoPayment;
  int? totalTransferPayment;
  int? totalDiscount;

  String? totalProductConvert;
  Map<String, dynamic>? productSales;

  int initialCostConvert = 0;
  int totalCashPaymentConvert = 0;
  int exchangeMomoConvert = 0;
  int exchangeBankConvert = 0;

  int? sumMomo;
  int? sumBank;
  int sumCash = 0;

  @override
  void initState() {
    super.initState();
    fetchDailySummary();
    sumInitialCost();
  }

  Future<void> sumDataExchange() async {
    setState(() {
      sumMomo = (totalMomoPayment ?? 0) + exchangeMomoConvert;
      sumBank = (totalTransferPayment ?? 0) + exchangeBankConvert;
      sumCash = totalCashPaymentConvert  + initialCostConvert;
    });
  }

  String formatDisplayMoney(int number) {
    return formatNumberWithComma(number.toString() + '000');
  }

  String formatNumberWithComma(String number) {
    // Chuyển chuỗi thành số và đảo ngược chuỗi để dễ dàng thêm dấu phẩy sau mỗi 3 chữ số
    String reversed = number.split('').reversed.join('');
    
    // Thêm dấu phẩy sau mỗi 3 chữ số
    String formatted = '';
    for (int i = 0; i < reversed.length; i++) {
      if (i != 0 && i % 3 == 0) {
        formatted += ' ,';
      }
      formatted += reversed[i];
    }
    
    // Đảo ngược lại chuỗi đã được định dạng và trả về kết quả
    return formatted.split('').reversed.join('');
  }

  Future<void> sumInitialCost() async {
    setState(() {
      initialCostConvert = ((initialCostConvert ) + totalCashPaymentConvert);
    });
  } 

  Future<void> fetchDailySummary() async {
    setState(() {
      _isLoading = true; // Bắt đầu tải dữ liệu
    });

    totalProductsSold = await orderService.getTotalProductsSoldToday();
    // totalRevenue = await orderService.getTotalRevenueToday(); // temp open
    totalCancelledOrders = await orderService.getTotalCancelledOrdersToday();
    totalCashPayment = await orderService.getTotalPaymentToday('Tien_mat');
    totalCashPaymentConvert =
    totalCashPayment != null ? totalCashPayment ?? 0 : 0;
    totalMomoPayment = await orderService.getTotalPaymentToday('Momo');
    totalTransferPayment = await orderService.getTotalPaymentToday('Chuyen_Khoan');
    productSales = await orderService.getProductSalesToday();
    totalDiscount = await orderService.getTotalDiscountToday();

    totalProductConvert = commonService.convertReturnSingle(await orderService.getDataWithCondition('generic',
        conditions: {
        'generic.name': 'totalProduct',
    }), 'value').toString();

    initialCostConvert = commonService.convertReturnSingle(await orderService.getDataWithCondition('generic',
      conditions: {
        'generic.name': 'initialCost',
    }), 'value');

    exchangeMomoConvert = commonService.convertReturnSingle(await orderService.getDataWithCondition('generic',
      conditions: {
        'generic.name': 'exchangeMomo'
    }), 'value');

    exchangeBankConvert = commonService.convertReturnSingle(await orderService.getDataWithCondition('generic',
      conditions: {
        'generic.name': 'exchangeBank'
    }), 'value');

    setState(() {
      _isLoading = false; // Hoàn thành tải dữ liệu
      sumDataExchange();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Tổng kết doanh thu hôm nay'),
      // ),
      appBar: AppBar(
        // backgroundColor: const Color.fromARGB(255, 82, 255, 246),
        backgroundColor: const Color.fromRGBO(98, 0, 239, 10),
        // leading: const Icon(Icons.account_balance ),
        automaticallyImplyLeading: false, // fix button back - screen report
        title: const Text(
          "Data summary report",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.assignment_add),
              onPressed: () {
                _showInputUpdateInitialCost(context);
              }),
          IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                // Call update totalProduct
                _showInputUpdateTotalProduct(context);
              })
        ],
      ),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Hiển thị loader khi đang tải dữ liệu
          : Padding(
              padding: const EdgeInsets.all(13.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ngày hôm nay: ${DateTime.now().toString().substring(0, 10)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tổng bột hôm nay: ${totalProductConvert}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Tổng số sản phẩm bán được: ${totalProductsSold ?? 0}',
                    style: TextStyle(fontSize: 16),
                  ),
                  // Text(
                  //   'Tổng doanh thu: ${totalRevenue ?? 0}',
                  //   style: TextStyle(fontSize: 16),
                  // ),
                  Text(
                    'Tổng tiền mặt hiện có: ${formatDisplayMoney(sumCash)} ₫',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),

                  Text(
                    'Tổng số đơn hàng bị hủy: ${totalCancelledOrders ?? 0}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  // Text(
                  //   'Tổng tiền mặt thu được: ${totalCashPayment ?? 0}',
                  //   style: TextStyle(fontSize: 16),
                  // ),
          

                  // Text(
                  //   'Tổng số tiền Momo: ${totalMomoPayment}  + (Đổi tiền) ${exchangeMomoConvert} = ${sumMomo}',
                  //   style: TextStyle(fontSize: 15),
                  // ),
                  // Text(
                  //   'Tổng số tiền chuyển khoản: ${totalTransferPayment} + (Đổi tiền) ${exchangeBankConvert} = ${sumBank} ',
                  //   style: TextStyle(fontSize: 15),
                  // ),
                  // SizedBox(height: 16),

                   RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Tổng tiền mặt thu được: ${formatDisplayMoney(totalCashPaymentConvert)} ₫',
                          style: TextStyle(color: Colors.black, fontSize: 16, fontStyle: FontStyle.normal),
                        ),
                      ],
                    ),
                  ),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Tổng momo:  ${ exchangeMomoConvert != 0 ? totalMomoPayment : formatDisplayMoney(totalMomoPayment ?? 0) + ' ₫'}',
                          style: TextStyle(color: Colors.black, fontSize: 16, fontStyle: FontStyle.normal),
                        ),
                        
                        if(exchangeMomoConvert != 0)
                        TextSpan(
                          text: ' + $exchangeMomoConvert (Đổi tiền)',
                          style: TextStyle(
                              color: Color.fromARGB(255, 248, 66, 42),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        if(exchangeMomoConvert != 0)
                        TextSpan(
                          text: ' =  ${formatDisplayMoney(sumMomo ?? 0)} ₫',
                          style: TextStyle(
                              color: Color.fromARGB(255, 50, 19, 226),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Tổng chuyển khoản: ${exchangeBankConvert != 0 ? totalTransferPayment : formatDisplayMoney(totalTransferPayment ?? 0) + ' ₫' } ',
                          style: TextStyle(color: Colors.black, fontSize: 16, fontStyle: FontStyle.normal),
                        ),

                        if(exchangeBankConvert != 0)
                        TextSpan(
                          text: ' + $exchangeBankConvert (Đổi tiền)',
                          style: TextStyle(
                              color: Color.fromARGB(255, 248, 66, 42),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        if(exchangeBankConvert != 0)
                        TextSpan(
                          text: ' =  ${formatDisplayMoney(sumBank ?? 0)} ₫',
                          style: TextStyle(
                              color: Color.fromARGB(255, 50, 19, 226),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  Text(
                    'Tổng số tiền discount: ${formatDisplayMoney(totalDiscount ?? 0)} ₫',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      //archive_outlined
                      Text(
                        'Số lượng bán được theo từng sản phẩm:',
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton( 
                        onPressed: () async {
                          totalRevenue = await orderService.getTotalRevenueToday(); // temp open
                          showDialog(context: context, builder: (context) => AppWidgetsCommon.generateDialog(context, 'Tổng tất cả sp bên dưới: ${formatDisplayMoney(totalRevenue ?? 0)} ₫ ', type: 1));
                        }, 
                        icon: Icon(Icons.archive_outlined)
                      )
                    ],
                  ),
                  
                  // Hiển thị số lượng bán được của từng sản phẩm
                  Expanded(
                    child: ListView.builder(
                      itemCount: productSales?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        String productName =
                            productSales?.keys.elementAt(index) ?? '';
                        int quantitySold =
                            productSales?.values.elementAt(index) ?? 0;
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
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _confirmDeleteOrder(context);
          },
          child: Icon(Icons.delete)),
    );
  }

  Future<void> _confirmDeleteOrder(BuildContext context) async {
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
                Navigator.of(context)
                    .pop(false); // Đóng hộp thoại và trả về giá trị false
              },
              child: Text("Không"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Đóng hộp thoại và trả về giá trị true
              },
              child: Text("Có"),
            ),
          ],
        );
      },
    );

    // Nếu người dùng xác nhận muốn xóa đơn hàng
    if (confirmDelete == true) {
      final db = await _databaseRepository.deleteOldDatabase();
      if (db == true) {
        await _databaseRepository.database;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Notification'),
            content: Text('Xóa thành công'),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => DashboardScreen()),
                  // );
                  exit(0);
                },
                child: Text('Đóng'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Notification'),
            content:
              Text('Có lỗi xảy ra khi xóa đơn hàng - vui lòng thử lại sau.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  fetchDailySummary();
                },
                child: Text('Đóng'),
              ),
            ],
          ),
        );
      }
    }
  }

  /**
   * Function show dialog update totalProducts
   */
  Future<void> _showInputUpdateTotalProduct(BuildContext context) async {
    TextEditingController _totalProductController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Nhập bột'),
            content: TextField(
              controller: _totalProductController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "XXX"), // placeholder
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
              TextButton(
                  onPressed: () async {
                    String inputTotalProductValue =
                        _totalProductController.text;

                    if(inputTotalProductValue == '') {
                      showDialog(context: context, builder: (context) => AppWidgetsCommon.generateDialog(context, "Chưa nhập dữ lệu bạn êy , Error đó !!"));
                      return;
                    }
                   
                    int resultUpdate = await orderService.updateGenericData(
                        inputTotalProductValue, 'totalProduct');

                    if (resultUpdate < 0) {
                      showDialog(context: context, builder: (context) => AppWidgetsCommon.generateDialog(context, "Đệt update fail !!"));
                      return;
                    }
                    // Update UI if necessary
                    setState(() {
                      totalProductConvert = inputTotalProductValue;
                      //  totalProductConvert = (int.parse(inputTotalProductValue)).toString(); -- dont fix
                    });

                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }

  /**
   * Function show dialog insert initial cost
   */
  Future<void> _showInputUpdateInitialCost(BuildContext context) async {
    TextEditingController _initialCostController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tổng tiền hom nay'),
            content: TextField(
              controller: _initialCostController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "600 K"),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('close')),
              TextButton(
                  onPressed: () async {
                    String initialCostValue = _initialCostController.text;

                    if(initialCostValue == '') {
                      showDialog(context: context, builder: (context) => AppWidgetsCommon.generateDialog(context, "Chưa nhập dữ lệu bạn êy , Error đó !!"));
                      return;
                    } 

                    int resultUpdate = await orderService.updateGenericData(
                        initialCostValue, 'initialCost');

                    if (resultUpdate < 0) {
                      showDialog(context: context, builder: (context) => AppWidgetsCommon.generateDialog(context, "Đệt update fail !!"));
                      return;
                    }

                    // after update generic - insert payment history
                    // copy process from _handelTransactionPayment()
                    // Handle data processing
                    Map<String, dynamic> dataInsert = {
                      'value_payment': int.parse(initialCostValue),
                      'type': Generic.isRevenue,
                      'note': "Tiền đầu giờ",
                    };

                    int insertResult = await commonService.insertData(
                        "transaction_history", dataInsert);

                    if (insertResult < 0) {
                      showDialog(context: context, builder: (context) => AppWidgetsCommon.generateDialog(context, "Mé Error insert ròi !!"));
                      return;
                    }

                    setState(() {
                      // update UI after Insert
                      initialCostConvert = int.parse(initialCostValue);
                      sumCash = totalCashPaymentConvert  + initialCostConvert;
                    });

                    Navigator.of(context).pop();
                  },
                  child: Text('Save'))
            ],
          );
        });
  }
}
