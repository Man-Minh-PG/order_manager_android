import 'package:grocery_app/helpers/database.dart';
import '../models/daily_report_model.dart';

class ReportService {
  final DatabaseRepository _dbRepo = DatabaseRepository.instance;

  Future<DailyReport> getDailyReport() async {
    final db = await _dbRepo.database;

    /// 🗓 Lọc theo ngày hôm nay
    final today = DateTime.now().toString().substring(0, 10);

    /// 💰 Tổng doanh thu
    final revenueResult = await db.rawQuery('''
      SELECT SUM(total) as totalRevenue
      FROM orders
      WHERE DATE(createdAt) = ? AND orders.status = 1
    ''', [today]);

    int totalRevenue = (revenueResult.first['totalRevenue'] ?? 0) as int;

    /// 💵 Tiền mặt
    final cashResult = await db.rawQuery('''
      SELECT SUM(o.total) as totalCash
      FROM orders o
      JOIN payment p ON o.paymentId = p.id
      WHERE p.name = 'Tien_mat'
      AND o.status = 1
      AND DATE(o.createdAt) = ?
    ''', [today]);

    int totalCash = (cashResult.first['totalCash'] ?? 0) as int;

    /// 🏦 Chuyển khoản
    final bankResult = await db.rawQuery('''
      SELECT SUM(o.total) as totalBank
      FROM orders o
      JOIN payment p ON o.paymentId = p.id
      WHERE p.name = 'Chuyen_Khoan'
      AND o.status = 1
      AND DATE(o.createdAt) = ?
    ''', [today]);

    int totalBank = (bankResult.first['totalBank'] ?? 0) as int;

    /// 📦 Tổng sản phẩm bán
    final soldResult = await db.rawQuery('''
      SELECT SUM(amount) as totalSold
      FROM order_detail
      WHERE DATE(createdAt) = ? AND order_detail.status = 1
    ''', [today]);

    int totalSold = (soldResult.first['totalSold'] ?? 0) as int;

    /// 📦 Tổng sản phẩm (generic)
    final totalProductResult = await db.query(
      'generic',
      where: 'name = ?',
      whereArgs: ['totalProduct'],
    );

    int totalProduct = int.tryParse(
          totalProductResult.isNotEmpty
              ? totalProductResult.first['value'].toString()
              : '0',
        ) ??
        0;

    /// 📦 tồn lý thuyết
    int theoreticalStock = totalProduct - totalSold;

    /// 💵 Tiền mặt thực tế (nếu có lưu)
    final actualCashResult = await db.query(
      'generic',
      where: 'name = ?',
      whereArgs: ['actualCash'],
    );

    int actualCash = int.tryParse(
          actualCashResult.isNotEmpty
              ? actualCashResult.first['value'].toString()
              : '0',
        ) ??
        totalCash;

    /// 🏦 tiền bank tính toán
    int bankCalculated = totalRevenue - actualCash;

    /// ⚖️ chênh lệch tiền
    int diffCash = actualCash - totalCash;

    return DailyReport(
      totalRevenue: totalRevenue,
      totalCash: totalCash,
      totalBank: totalBank,
      totalProduct: totalProduct,
      totalSold: totalSold,
      theoreticalStock: theoreticalStock,
      actualCash: actualCash,
      bankCalculated: bankCalculated,
      diffCash: diffCash,
    );
  }
}