import 'package:order_manager/models/order_details.dart';
import 'package:order_manager/models/orders.dart';

// ignore: camel_case_types
class Orders {
  final int?      id;
  final String    total;
  final double    note;
  // ignore: non_constant_identifier_names
  final int?      payment_id;
  final int?      status;
  // ignore: non_constant_identifier_names
  final DateTime  created_at;
  OrderDetails    orderDetail;

  // create contructor
  Orders({
    this.id,
    required this.total,
    required this.note,
    // ignore: non_constant_identifier_names
    this.payment_id,
    this.status,
    // ignore: non_constant_identifier_names
    required this.created_at
  });


  factory Orders.fromMap(Map<String, dynamic>json ) => Orders(
    id:         json['id'],
    total:      json['total'],
    note:       json['note'], 
    payment_id: json['payment_id'], 
    status:     json['status'],
    created_at: json['created_at'],
  );

  // create Map data
  Map<String, dynamic> toMap() {
    return {
      'id'            : id,
      'total'         : total,
      'note'          : note,
      'payment_id'    : payment_id,
      'status'        : status,
      'created_at'    : created_at,
    };
  }
}