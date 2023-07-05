// ignore: camel_case_types
class orders_detail {
  final int?      id;
  // ignore: non_constant_identifier_names
  final int       product_id;
  // ignore: non_constant_identifier_names
  final int       order_id;
  // ignore: non_constant_identifier_names
  final int?      amount;
  final int?      status;
  // ignore: non_constant_identifier_names
  final DateTime  created_at;

  // create contructor
  orders_detail({
    this.id,
    // ignore: non_constant_identifier_names
    required this.product_id,
    // ignore: non_constant_identifier_names
    required this.order_id,
    // ignore: non_constant_identifier_names
    this.amount,
    this.status,
    // ignore: non_constant_identifier_names
    required this.created_at
  });


  factory orders_detail.fromMap(Map<String, dynamic>json ) => orders_detail(
    id:              json['id'],
    product_id:      json['product_id'],
    order_id:        json['order_id'], 
    amount:          json['amount'], 
    status:          json['status'],
    created_at:      json['created_at'],
  );

  // create Map data
  Map<String, dynamic> toMap() {
    return {
      'id'            : id,
      'product_id'    : product_id,
      'order_id'      : order_id,
      'amount'        : amount,
      'status'        : status,
      'created_at'    : created_at,
    };
  }
}