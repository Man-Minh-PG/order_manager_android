class Payment {
  int id;
  String name;
  int status;
  String createdAt;

  Payment({
    required this.id,
    required this.name,
    this.status = 0,
    required this.createdAt,
  });

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      name: map['name'],
      status: map['status'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
