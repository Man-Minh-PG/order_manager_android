class OrderDetail {
  int id;
  int productId;
  int orderId;
  int amount;
  int status;
  String createdAt;

  OrderDetail({
    required this.id,
    required this.productId,
    required this.orderId,
    required this.amount,
    this.status = 0,
    required this.createdAt,
  });

  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
      id: map['id'],
      productId: map['productId'],
      orderId: map['orderId'],
      amount: map['amount'],
      status: map['status'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'orderId': orderId,
      'amount': amount,
      'status': status,
      'createdAt': createdAt,
    };
  }
}