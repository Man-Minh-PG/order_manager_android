// import 'package:grocery_app/models/order_model.dart';
import 'package:grocery_app/models/product_model.dart';
// import 'package:grocery_app/models/grocery_item.dart';
// import 'package:grocery_app/repository/order_repository.dart'; // Import the order repository
import 'package:grocery_app/helpers/database.dart'; // Import the database helper

class OrderService {
  final DatabaseRepository _databaseRepository = DatabaseRepository.instance;
  // final OrderRepository _orderRepository = OrderRepository();

  // Future<void> addProductToOrder(Order order, GroceryItem groceryItem) async {
  Future<bool> createOrder(List<Product> groceryItem, String note) async {
  final db = await _databaseRepository.database;

  if (db == null) {
    // Xử lý khi db là null, ví dụ: thông báo lỗi hoặc kết thúc hàm
    print('Error: Database is null');
    return false; // Trả về false để chỉ ra rằng insert thất bại
  }

  int totalPrice = 0;
  int insertedIdOrder = 0;

  // Tính tổng giá tiền của đơn hàng
  for (var item in groceryItem) {
    totalPrice += item.price;
  }

  // Insert thông tin đơn hàng vào bảng orders
  insertedIdOrder = await db.insert(
    'orders',
    <String, dynamic>
    
    {
      'total': totalPrice,
      'note': note,
      'paymentId' : 0, // Phương thức thanh toán bằng tiền mặt
    },
  );

  // Kiểm tra xem insert vào bảng orders có thành công hay không
  if (insertedIdOrder == 0) {
    print('Error: Insert order failed');
    return false; // Trả về false để chỉ ra rằng insert thất bại
  }

  // Insert thông tin chi tiết đơn hàng vào bảng order_detail
  for (var item in groceryItem) {
    int result = await db.insert(
      'order_detail',
      <String, dynamic>{
        'productId': item.id,
        'orderId': insertedIdOrder,
        'amount' : item.orderQuantity,
      },
    );
    
    // Kiểm tra xem insert vào bảng order_detail có thành công hay không
    if (result == 0) {
      print('Error: Insert order detail failed');
      return false; // Trả về false để chỉ ra rằng insert thất bại
    }
  }

  // Trả về true để chỉ ra rằng insert thành công
  return true;
}


  // Future<List<Map<String, dynamic>>> selectOrdersWithStatus0() async {
  //   final db = await _databaseRepository.database;
  //   return await db!.rawQuery('''
  //     SELECT orders.*, order_detail.*
  //     FROM orders
  //     JOIN order_detail ON orders.id = order_detail.orderId
  //     WHERE orders.status = 0
  //   ''');
  // }

   Future<List<Map<String, dynamic>>> selectOrdersWithStatus0() async {
    final db = await _databaseRepository.database;
    return await db!.rawQuery('''
      SELECT order_detail.*, orders.*, order_detail.id AS order_detail_id, product.name AS product_name
      FROM order_detail
      JOIN orders ON orders.id = order_detail.orderID
      JOIN product ON product.id = order_detail.productId 
      WHERE orders.status = 0
    ''');
  }

  Future<void> updateOrderStatus(int orderId, int newStatus) async {
    final db = await _databaseRepository.database;
    await db!.update(
      'orders',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }
}