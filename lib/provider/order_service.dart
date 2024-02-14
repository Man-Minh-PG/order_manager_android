import 'dart:js_interop';

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
    int totalPrice = 0;
    final db = await _databaseRepository.database;
    
    // Set the exclusiveOffers value for the product based on the predefined value in the GroceryItem class
    for (var item in groceryItem) {
      totalPrice += item.price;
    }

    // Insert the order detail into the detail table
   int insertedIdOrder = await db!.insert(
      'order',
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
      SELECT orders.*, order_detail.*
      FROM orders
      JOIN order_detail ON orders.id = order_detail.order_id
      WHERE order_detail.status = 0
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