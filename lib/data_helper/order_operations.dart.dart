// ignore_for_file: depend_on_referenced_packages
import 'database_helper.dart';
import 'package:order_manager/models/order.dart';
import 'package:order_manager/models/order_detail.dart';

// /**
// * Note: task flutter 5
// * branch master : add config package 
// * dependencies:
// *   intl: ^0.17.0
// * 
// * When testing add import 
// * import 'package:intl/intl.dart'; // Thêm import test convert Datetime now 
// */

class OrderOperations {
  final dbProvider = DatabaseRepository.instance;

  // /**
  // *  Process create order
  // *  With 3 steps
  // */
  // first step create order 
  Future<int?> createOrder(Order order) async {
    final db = await dbProvider.database;
    int?  orderId = db?.insert('order', order.toMap()) as int?;

    // ignore: avoid_print
    print('insert success id: $orderId');
    return orderId; 
  }

  // second step create order detail with id of order
  void createOrderDetailWithOrderId(int orderId, OrderDetail orderDetail) async {
    orderDetail.order_id = orderId; // Note Task 4 - Assign order ID to order details 
    final db             = await dbProvider.database;
    db?.insert('order_detail', orderDetail.toMap());
    // ignore: avoid_print
    print('order detail inserted');
  }
    
  void createOrderDetail(Order order, List<OrderDetail> orderDetails) async {
    int? orderId = await createOrder(order);

    for(var item in orderDetails) {
      createOrderDetailWithOrderId(orderId!, item); 
    }
  }
   
  // /**
  // *  Process get list order
  // *  1 order <=> n order detail
  // */
  Future<List<Order>> fetchOrdersWithDetailsToday() async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    
    final db = await dbProvider.database;

    final List<Map<String, dynamic>> result = await db!.rawQuery(
      '''
      SELECT order_table.*, order_detail_table.*
      FROM order_table
      JOIN order_detail_table ON order_table.order_id = order_detail_table.order_id
      WHERE DATE(order_table.created_at) = DATE(?)
      ''',
      [today.toIso8601String()],
    );

    final Map<int, Order> orderMap = {};

    for (final row in result) {
      final order = orderMap.putIfAbsent(
        row['order_id'],
        () => Order.fromMap(row),
      );
      order.orderDetails.add(OrderDetail.fromMap(row));
    }

    final List<Order> orders = orderMap.values.toList();
    return orders;
  }

  // /**
  // *  Process update order
  // *  1. update status order
  // *  2. update amount item in order
  // *  3. update status cancel order
  // */
  Future<void> updateOrderStatus(int orderId) async {
  final db = await dbProvider.database;
  
  await db?.update(
    'order_table',
    {'status': 1},
    where: 'order_id = ?',
    whereArgs: [orderId],
  );
  
  // Gọi hàm fetchOrdersWithDetailsToday để cập nhật lại danh sách sau khi cập nhật trạng thái
  await fetchOrdersWithDetailsToday();
}


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