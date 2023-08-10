import 'package:order_manager_android/data_helper/database_helper.dart';
import 'package:order_manager_android/models/orders_detail_object.dart';
import 'package:order_manager_android/models/orders_object.dart';

class OrderOperations {
  OrderOperations orderOperations;

  final dbProvider = DatabaseRepository.instance;

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
    // id          INTEGER PRIMARY KEY AUTOINCREMENT,
    //       total       REAL NOT NULL,
    //       note        TEXT,
    //       payment_id  INTEGER,
    //       status      INTEGER, 
    //       created_at  TEXT NOT NULL,
    //       FOREIGN KEY (payment_id) REFERENCES payment (id)
   
}