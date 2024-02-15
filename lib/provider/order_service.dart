import 'package:grocery_app/models/order_model.dart';
import 'package:grocery_app/models/product_model.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/repository/order_repository.dart'; // Import the order repository
import 'package:grocery_app/helpers/database.dart'; // Import the database helper

class OrderService {
  final DatabaseRepository _databaseRepository = DatabaseRepository.instance;
  final OrderRepository _orderRepository = OrderRepository();

  // Future<void> addProductToOrder(Order order, GroceryItem groceryItem) async {
  Future<void> createOrder(List<Product> groceryItem, String note) async {
    final db = await _databaseRepository.database;


    if (db == null) {
      // Xử lý khi db là null, ví dụ: thông báo lỗi hoặc kết thúc hàm
      print('Error: Database is null');
      return;
    }


    int totalPrice = 0;
    int insertedIdOrder = 0;
   
    // Set the exclusiveOffers value for the product based on the predefined value in the GroceryItem class
    for (var item in groceryItem) {
      totalPrice += item.price;
    }

    // Insert the order detail into the detail table
   insertedIdOrder = await db!.insert(
      'orders',
      <String, dynamic>{
        'total': totalPrice,
        'note': note,
        'paymentId' : 0, // cash payment
      },
    );

     for (var item in groceryItem) {
      await db.insert(
      'order_detail',
      <String, dynamic>{
        'productId': item.id,
        'orderId': insertedIdOrder,
        'amount' : item.orderQuantity, // cash payment
      },
    );
    }
  }

  Future<List<Map<String, dynamic>>> selectOrdersWithStatus0() async {
    final db = await _databaseRepository.database;
    return await db!.rawQuery('''
      SELECT order.*, order_detail.*
      FROM order
      JOIN order_detail ON order.id = order_detail.order_id
      WHERE order.status = 0
    ''');
  }


  Future<void> updateOrderStatus(int orderId, int newStatus) async {
    final db = await _databaseRepository.database;
    await db!.update(
      'order',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }
}