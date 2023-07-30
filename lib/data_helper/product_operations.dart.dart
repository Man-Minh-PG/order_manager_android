import 'database_helper.dart';
import 'package:order_manager/objects/products_object.dart';

class ProductOperations{ 
  late ProductOperations productOperations;

  final dbProvider = DatabaseRepository.instance;

  createProduct(Product product) async {
    final db = await dbProvider.database;
    db?.insert('product', product.toMap());
  }

  updateProduct(Product product) async {
    final db = await dbProvider.database;
    db?.update('product', product.toMap(),
       where: 'id=?', whereArgs: [product.id]);
    } 

  deleteProduct(Product product) async {
    final db = await dbProvider.database;
    await db?.delete('product', where: 'id=?', whereArgs: [product.id]);
  }

  Future<List<Product>> getAllProduct() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db!.query('product');
    List<Product> products = 
    allRows.map((product) => Product.fromMap(product)).toList();
    return products;
  }

  Future<List<Product>> searchProduct(String keyword) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db!.query('product', where: 'name LIKE %?%', whereArgs: ['%$keyword%']);

    List<Product> products =
    allRows.map((product) => Product.fromMap(product)).toList();
    return products;
  }
}
      
//https://www.youtube.com/watch?v=noi6aYsP7Go
// https://www.youtube.com/watch?v=xWt7dwcR1jo

// forgerin key 
// https://www.youtube.com/watch?v=lLqPIulkQYg