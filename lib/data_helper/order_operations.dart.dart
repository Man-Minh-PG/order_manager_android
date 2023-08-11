import 'package:order_manager_android/data_helper/database_helper.dart';
import 'package:order_manager_android/models/order_detail.dart';
import 'package:order_manager_android/models/order.dart';


/**
* Note: task flutter 5
* branch master : add config package 
* dependencies:
*   intl: ^0.17.0
* 
* When testing add import 
* import 'package:intl/intl.dart'; // Thêm import test convert Datetime now 
*/

class OrderOperations {
  OrderOperations orderOperations;

  final dbProvider = DatabaseRepository.instance;

  /**
  *  Process create order
  *  With 3 steps
  */
  // first step create order 
  Future<int> createOrder(Order order) async {
    final db = await dbProvider.database;
    int?  orderId = db?.insert('order', order.toMap());

    print('insert success id: $orderId');
    return orderId; 
  }

  // second step create order detail with id of order
  void createOrderDetailWithOrderId(int orderId, OrderDetail orderDetail) async {
    orderDetail.order_id = orderId; // Note Task 4 - Assign order ID to order details 
    final db             = await dbProvider.database;
    db.insert('order_detail', orderDetail.toMap());
    print('order detail inserted');
  }
    
  void createOrderDetail(Order order, List<OrderDetail> orderDetails) async {
    int orderId = await createOrder(order);

    for(var item in orderDetails) {
      createOrderDetailWithOrderId(orderId, item);
    }
  }
   
  /**
  *  Process get list order
  *  1 order <=> n order detail
  */


  /**
  *  Process update order
  *  1. update status order
  *  2. update amount item in order
  *  3. update status cancel order
  */

  /**
  *  Process delete order
  *  delete not remove
  */

  /**
  *  Note task flutter 02
  *  
  */
  //  Future<int> getLastId() async {
  //   final db = await database;
  //   var result = await db.rawQuery('SELECT id FROM _detail ORDER BY id DESC LIMIT 1');
  //   if (result.isEmpty) return -1; // No records found
  //   return result.first['id'];
  // }

}