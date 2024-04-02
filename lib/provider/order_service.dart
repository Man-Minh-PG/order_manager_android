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


  Future<bool> editOrder(List<Product> groceryItem, String note, List<int> orderDetailId) async {
    final db = await _databaseRepository.database;
    
    if (db == null) {
      // Xử lý khi db là null, ví dụ: thông báo lỗi hoặc kết thúc hàm
      print('Error: Database is null');
      return false; // Trả về false để chỉ ra rằng insert thất bại
    }

    int totalPrice = 0;
    int insertedIdOrder = 0;

    for (var id in orderDetailId) {
      await db.delete(
        'order_detail', 
        where: 'id = ?',
        whereArgs: [id],
      );
    }

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
    // final db = await _databaseRepository.database;
    //   List<Map<String, dynamic>> ordersFromDB = await db!.rawQuery('''
    //     SELECT order_detail.*, orders.*, order_detail.id AS order_detail_id, product.name AS product_name
    //     FROM order_detail
    //     JOIN orders ON orders.id = order_detail.orderID
    //     JOIN product ON product.id = order_detail.productId 
    //     WHERE orders.status = 0
    //   ''');

    //   // Tạo danh sách mới để lưu trữ các đơn hàng với thuộc tính paymentMethod
    //   List<Map<String, dynamic>> orders = [];

    //   // Thêm thuộc tính paymentMethod vào mỗi phần tử trong danh sách mới
    //   for (var order in ordersFromDB) {
    //     Map<String, dynamic> modifiedOrder = Map.from(order);
    //     modifiedOrder['paymentMethod'] = 1; // Thay cashPayment bằng giá trị tương ứng của paymentMethod
    //     orders.add(modifiedOrder);
    //   }

    //   return orders;

      final db = await _databaseRepository.database;
      List<Map<String, dynamic>> ordersFromDB = await db!.rawQuery('''
        SELECT order_detail.*, orders.*, order_detail.id AS order_detail_id, product.name AS product_name, orders.paymentId AS paymentMethod
        FROM order_detail
        JOIN orders ON orders.id = order_detail.orderID
        JOIN product ON product.id = order_detail.productId 
        WHERE orders.status = 0
      ''');

        // Tạo danh sách mới để lưu trữ các đơn hàng với thuộc tính paymentMethod
      List<Map<String, dynamic>> orders = [];

      // Thêm thuộc tính paymentMethod vào mỗi phần tử trong danh sách mới
      for (var order in ordersFromDB) {
        Map<String, dynamic> modifiedOrder = Map.from(order);
  
        orders.add(modifiedOrder);
      }

       return orders;
  }

  Future<List<Map<String, dynamic>>> selectOrdersWithStatus1() async { // Status = 1 means paid
  // final db = await _databaseRepository.database;
  //  return await db!.rawQuery('''
  //   SELECT order_detail.*, orders.*, order_detail.id AS order_detail_id, orders.paymentId AS paymentMethod
  //   product.name AS product_name, payment.name AS paymentName,
  //   orders.status AS orderStatus
  //   FROM order_detail
  //   JOIN orders ON orders.id = order_detail.orderID
  //   JOIN product ON product.id = order_detail.productId
  //   JOIN payment ON payment.id = orders.paymentId
  //   WHERE orders.status IN (1, 2)
  // ''');

       final db = await _databaseRepository.database;
      List<Map<String, dynamic>> ordersFromDB = await db!.rawQuery('''
       SELECT order_detail.*, orders.*, order_detail.id AS order_detail_id, orders.paymentId AS paymentMethod,
            product.name AS product_name, payment.name AS paymentName,
            orders.status AS orderStatus
            FROM order_detail
            JOIN orders ON orders.id = order_detail.orderID
            JOIN product ON product.id = order_detail.productId
            JOIN payment ON payment.id = orders.paymentId
            WHERE orders.status IN (1, 2)
      ''');

        // Tạo danh sách mới để lưu trữ các đơn hàng với thuộc tính paymentMethod
      List<Map<String, dynamic>> orders = [];

      // Thêm thuộc tính paymentMethod vào mỗi phần tử trong danh sách mới
      for (var order in ordersFromDB) {
        Map<String, dynamic> modifiedOrder = Map.from(order);
  
        orders.add(modifiedOrder);
      }

       return orders;
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
  // Lấy tổng số lượng sản phẩm được bán trong ngày
Future<int> getTotalProductsSoldToday() async {
  final db = await _databaseRepository.database;
  final result = await db!.rawQuery('''
    SELECT IFNULL(SUM(order_detail.amount), 0) AS totalProductsSold
    FROM orders
    JOIN order_detail ON order_detail.orderId = orders.id
    JOIN product ON product.id = order_detail.productId
    WHERE orders.status = 1;
  ''');
  return result.isNotEmpty ? result.first['totalProductsSold'] as int ?? 0 : 0;
}

// Lấy tổng doanh thu trong ngày
    Future<int> getTotalRevenueToday() async {
      final db = await _databaseRepository.database;
      final result = await db!.rawQuery('''
        SELECT IFNULL(SUM(total), 0) AS totalRevenue
        FROM orders
        WHERE orders.status = 1
      ''');
      return result.isNotEmpty ? result.first['totalRevenue'] as int ?? 0 : 0;
    }

    // Lấy tổng số đơn hàng bị hủy trong ngày
    Future<int> getTotalCancelledOrdersToday() async {
      final db = await _databaseRepository.database;
      final result = await db!.rawQuery('''
        SELECT COUNT(*) as totalCancelledOrders
        FROM orders
        WHERE status = 2
      ''');
      return result.isNotEmpty ? result.first['totalCancelledOrders'] as int ?? 0 : 0;
    }

  // Lấy tổng số tiền thanh toán bằng mỗi phương thức (tiền mặt, Momo, chuyển khoản) trong ngày
  Future<int> getTotalPaymentToday(String paymentMethod) async {
    final db = await _databaseRepository.database;
    var result = await db!.rawQuery('''
      SELECT IFNULL(SUM(orders.total), 0) AS totalPayment
      FROM orders
      JOIN payment ON orders.paymentId = payment.id
      WHERE orders.status = 1
      AND payment.name = ?
    ''', [paymentMethod]);

    // Kiểm tra nếu result.isEmpty trước khi truy cập dữ liệu từ kết quả truy vấn
    if (result.isNotEmpty) {
      int totalPayment = result.first['totalPayment'] as int;
      return totalPayment;
    } else {
      // Trả về 0 nếu không có dữ liệu trả về từ truy vấn
      return 0;
    }
  }

  // Lấy số lượng bán được của từng sản phẩm trong ngày
  Future<Map<String, int>> getProductSalesToday() async {
    final db = await _databaseRepository.database;
    final result = await db!.rawQuery('''
      SELECT product.name AS name,  IFNULL(SUM(order_detail.amount), 0) AS quantitySold
      FROM orders
      JOIN order_detail ON order_detail.orderId = orders.id
      JOIN product ON product.id = order_detail.productId
      WHERE orders.status = 1
      GROUP BY product.id
    ''');
    // print(result);
    return Map.fromIterable(
      result,
      key: (item) => item['name'] as String,
      value: (item) => item['quantitySold'] as int,
    );
  }

  Future<List<Map<String, dynamic>>> selectOrderWithID(int idOrder) async { // Status = 1 means paid
  final db = await _databaseRepository.database;
  return await db!.rawQuery('''
    SELECT orders.id as orderId, order_detail.id as orderDetailId, product.id as productId, order_detail.amount
    FROM orders
    JOIN order_detail ON order_detail.orderId = orders.id
    JOIN product ON product.id = order_detail.productId
      WHERE 
      orders.id = ?
    ''', [idOrder]);
}

}