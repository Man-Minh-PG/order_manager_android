/**
 * 2026: Man note < class mapping data not add DB >
 */
class DailyReport {
  final int totalRevenue;
  final int totalCash;
  final int totalBank;

  final int totalProduct;
  final int totalSold;
  final int theoreticalStock;

  final int actualCash;
  final int bankCalculated;
  final int diffCash;

  DailyReport({
    required this.totalRevenue,
    required this.totalCash,
    required this.totalBank,
    required this.totalProduct,
    required this.totalSold,
    required this.theoreticalStock,
    required this.actualCash,
    required this.bankCalculated,
    required this.diffCash,
  });
}