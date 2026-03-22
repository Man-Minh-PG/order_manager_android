import 'package:grocery_app/helpers/database.dart';
import 'package:grocery_app/models/product.dart';

class ProductService  {

  final db = DatabaseRepository.instance;

  Future<List<Product>> getProducts() async {
    final maps = await db.query('product');
    return maps.map((e) => Product.fromMap(e)).toList();
  }

  Future<void> updateProduct(Product product) async {
    await db.update(
      'product',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> deleteProduct(int id) async {
    await db.delete('product', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertProduct(Product product) async {
    await db.insert('product', product.toMap());
  }
}