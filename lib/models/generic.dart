class Generic {
  int id;
  String name;
  String? value;
  int status;
  String createdAt;

  // Define variable
  static const int  isExpenses = 0;
  static const int  isRevenue = 1;

  Generic({
    required this.id,
    required this.name,
    this.value,
    this.status = 0,
    required this.createdAt,
  });

  factory Generic.fromMap(Map<String, dynamic> map) {
    return Generic(
      id: map['id'],
      name: map['name'],
      value: map['value'],
      status: map['status'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'status': status,
      'createdAt': createdAt,
    };
  }
}