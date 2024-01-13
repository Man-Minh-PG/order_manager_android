import 'package:grocery_app/helpers/database.dart';
import 'package:grocery_app/models/product.dart';

class ProductProvider {

  final databaseProvider = DatabaseRepository.instance;

  Future<int> insertProduct(Product product) async {
    return await databaseProvider.insert('product', product.toMap());
  }

  Future<List<Product>> getProducts() async {
    final List<Map<String, dynamic>> maps = await databaseProvider.query('product');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<int> updateProduct(Product product) async {
    return await databaseProvider.update(
      'product',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    return await databaseProvider.delete(
      'product',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}