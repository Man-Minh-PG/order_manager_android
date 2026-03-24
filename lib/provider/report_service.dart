import 'package:grocery_app/helpers/database.dart';
import '../models/daily_report_model.dart';

class ReportService {
  final DatabaseRepository _dbRepo = DatabaseRepository.instance;

  Future<DailyReport> getDailyReport() async {
    final db = await _dbRepo.database;
    final today = DateTime.now().toString().substring(0, 10);

    /// 💰 Tổng doanh thu
    final revenue = await db.rawQuery('''
      SELECT IFNULL(SUM(total), 0) as totalRevenue
      FROM orders
      WHERE status = 1
    ''');

    final totalRevenue = (revenue.first['totalRevenue'] ?? 0) as int;

    /// 💵 Tiền mặt
    final cash = await db.rawQuery('''
      SELECT IFNULL(SUM(o.total), 0) as totalCash
      FROM orders o
      JOIN payment p ON o.paymentId = p.id
      WHERE p.name = 'Tien_mat' AND o.status = 1
    ''');

    final totalCash = (cash.first['totalCash'] ?? 0) as int;

    /// 🏦 Bank
    final bank = await db.rawQuery('''
      SELECT IFNULL(SUM(o.total), 0) as totalBank
      FROM orders o
      JOIN payment p ON o.paymentId = p.id
      WHERE p.name = 'Chuyen_Khoan' AND o.status = 1
    ''');

    final totalBank = (bank.first['totalBank'] ?? 0) as int;

    /// 📦 Đã bán
    final sold = await db.rawQuery('''
      SELECT IFNULL(SUM(order_detail.amount), 0) AS totalProductsSold
      FROM orders
      JOIN order_detail ON order_detail.orderId = orders.id
      JOIN product ON product.id = order_detail.productId
      WHERE orders.status = 1 AND product.isSpecialProduct = 0
    ''');

    final totalSold = sold.first['totalProductsSold'] as int;

    /// 📦 Tổng sản phẩm
    final totalProductResult = await db.query(
      'generic',
      where: 'name = ?',
      whereArgs: ['totalProduct'],
    );

    final totalProduct = int.tryParse(
          totalProductResult.isNotEmpty
              ? totalProductResult.first['value'].toString()
              : '0',
        ) ??
        0;

    final theoreticalStock = totalProduct - totalSold;

    /// 💵 actual cash (fix lỗi insert/update)
    final actualCashResult = await db.query(
      'generic',
      where: 'name = ?',
      whereArgs: ['actualCash'],
    );

    final actualCash = int.tryParse(
          actualCashResult.isNotEmpty
              ? actualCashResult.first['value'].toString()
              : totalCash.toString(),
        ) ??
        totalCash;

    /// 💸 chênh lệch
    final diffCash = actualCash - totalCash;

    /// 💡 Giá trung bình
    final avgPriceResult = await db.rawQuery('''
      SELECT AVG(p.price) as avgPrice
      FROM order_detail od
      JOIN product p ON od.productId = p.id
      WHERE DATE(od.createdAt) = DATE(?)
    ''', [today]);

    final avgPrice = (avgPriceResult.first['avgPrice'] as num?)?.toDouble() ?? 0.0;

    /// 🔥 suy ra bánh thiếu
    double missingProduct = 0;
    if (diffCash < 0 && avgPrice > 0) {
      missingProduct = diffCash.abs() / avgPrice;
    }

    return DailyReport(
      totalRevenue: totalRevenue,
      totalCash: totalCash,
      totalBank: totalBank,
      totalProduct: totalProduct,
      totalSold: totalSold,
      theoreticalStock: theoreticalStock,
      actualCash: actualCash,
      bankCalculated: totalRevenue - actualCash,
      diffCash: diffCash,
      missingProduct: missingProduct,
    );
  }
}