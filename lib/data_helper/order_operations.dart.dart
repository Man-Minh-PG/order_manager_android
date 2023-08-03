import 'database_helper.dart';
import 'package:order_manager/models/order_details.dart';
import 'package:order_manager/models/orders.dart';

class OrderOperations {
  OrderOperations orderOperations;

  final dbProvider = DatabaseRepository.instance;

  Future<int> createOrderDetail(OrderDetails orderDetails) async {
    final db = await dbProvider.database;
    int   id = await db!.insert('order_detail', orderDetails.toMap());

    print('orderdetail inserted');
    return id; 
  }
    
  Future<void> createOrder(Orders orders) async {
    final db          = await dbProvider.database;
    int orderDetailId = await createOrderDetail(orders.)
  }
}