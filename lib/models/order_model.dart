import 'package:grocery_app/models/product_model.dart';
class Order {
  List<Product> _products = [];
  List<Product> get products => _products;

  int id;
  int total;
  String note;
  int? paymentId;
  int status;
  String createdAt;

  static const noPayment = 0; 
  static const cashPayment = 1;
  static const momoPayment = 2;
  static const transferPayment = 3;

  static const isDiscount = 1;
  static const orderNoDiscount = 0;

  static const orderStatusDefault = 0;
  static const orderStatusSucess = 1;
  static const orderStatusCancel = 2;

  Order({
    required this.id,
    required this.total,
    this.note = '',
    this.paymentId,
    this.status = 0,
    required this.createdAt,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      total: map['total'],
      note: map['note'],
      paymentId: map['paymentId'],
      status: map['status'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'total': total,
      'note': note,
      'paymentId': paymentId,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
