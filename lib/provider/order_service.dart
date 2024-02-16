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

   Future<List<Map<String, dynamic>>> selectOrdersWithStatus0() async { // Status = 0 means a new order has not been paid
    final db = await _databaseRepository.database;
    return await db!.rawQuery('''
      SELECT order_detail.*, orders.*, order_detail.id AS order_detail_id, product.name AS product_name
      FROM order_detail
      JOIN orders ON orders.id = order_detail.orderID
      JOIN product ON product.id = order_detail.productId 
      WHERE orders.status = 0
    ''');
  }

  Future<List<Map<String, dynamic>>> selectOrdersWithStatus1() async { // Status = 1 means paid
  final db = await _databaseRepository.database;
  return await db!.rawQuery('''
    SELECT order_detail.*, orders.*, order_detail.id AS order_detail_id, product.name AS product_name, payment.name AS paymentName, orders.status AS orderStatus
    FROM order_detail
    JOIN orders ON orders.id = order_detail.orderID
    JOIN product ON product.id = order_detail.productId
    JOIN payment ON payment.id = orders.paymentId
    WHERE orders.status = 1 OR orders.status = 2
  ''');
}


  Future<int> updateOrderStatus(int orderId, int newStatus, int paymentId) async {
    final db = await _databaseRepository.database;
    int resultUpdate = 0;

    resultUpdate = await db!.update(
      'orders',
      {
        'status': newStatus,
        'paymentId': paymentId
      },
      where: 'id = ?',
      whereArgs: [orderId],
    );

    return resultUpdate;
  }

  // Lấy tổng số sản phẩm bán được trong ngày
  Future<Object> getTotalProductsSoldToday() async {
    final db = await _databaseRepository.database;
    final result = await db!.rawQuery('''
      SELECT SUM(amount) as totalProductsSold
      FROM order_detail
      JOIN orders ON orders.id = order_detail.orderId
      WHERE DATE(orders.createdAt) = DATE('now')
    ''');
    return result.isNotEmpty ? result.first['totalProductsSold'] ?? 0 : 0;
  }

  // Lấy tổng doanh thu trong ngày
  Future<Object> getTotalRevenueToday() async {
    final db = await _databaseRepository.database;
    final result = await db!.rawQuery('''
      SELECT SUM(total) as totalRevenue
      FROM orders
      WHERE DATE(createdAt) = DATE('now')
    ''');
    return result.isNotEmpty ? result.first['totalRevenue'] ?? 0 : 0;
  }

  // Lấy tổng số đơn hàng bị hủy trong ngày
  Future<Object> getTotalCancelledOrdersToday() async {
    final db = await _databaseRepository.database;
    final result = await db!.rawQuery('''
      SELECT COUNT(*) as totalCancelledOrders
      FROM orders
      WHERE status = 2 AND DATE(createdAt) = DATE('now')
    ''');
    return result.isNotEmpty ? result.first['totalCancelledOrders'] ?? 0 : 0;
  }

  // Lấy tổng số tiền thanh toán bằng mỗi phương thức (tiền mặt, Momo, chuyển khoản) trong ngày
  Future<Object> getTotalPaymentToday(String paymentMethod) async {
    final db = await _databaseRepository.database;
    final result = await db!.rawQuery('''
      SELECT SUM(total) as totalPayment
      FROM orders
      WHERE paymentId = (
        SELECT id
        FROM payment
        WHERE name = ?
      ) AND DATE(createdAt) = DATE('now')
    ''', [paymentMethod]);
    return result.isNotEmpty ? result.first['totalPayment'] ?? 0 : 0;
  }

  // Lấy số lượng bán được của từng sản phẩm trong ngày
  Future<Map<String, int>> getProductSalesToday() async {
    final db = await _databaseRepository.database;
    final result = await db!.rawQuery('''
      SELECT product.name, SUM(order_detail.amount) as quantitySold
      FROM order_detail
      JOIN product ON product.id = order_detail.productId
      JOIN orders ON orders.id = order_detail.orderId
      WHERE DATE(orders.createdAt) = DATE('now')
      GROUP BY product.name
    ''');
    return Map.fromIterable(
      result,
      key: (item) => item['name'] as String,
      value: (item) => item['quantitySold'] as int,
    );
  }

}