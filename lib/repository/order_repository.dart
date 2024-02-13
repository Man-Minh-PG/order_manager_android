import 'package:grocery_app/helpers/database.dart'; // Import the database helper
import 'package:sqflite/sqflite.dart';
import 'package:grocery_app/models/order_model.dart';
import 'package:grocery_app/models/product_model.dart';

class OrderRepository {
  final DatabaseRepository _databaseRepository = DatabaseRepository.instance;

  Future<void> insertOrderDetail(int orderId, int productId) async {
    final db = await _databaseRepository.database;

    // Insert the order detail into the detail table
    await db!.insert(
      'order_detail',
      <String, dynamic>{
        'order_id': orderId,
        'product_id': productId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}