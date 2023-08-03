class Product {
  final int?      id;
  final String    name;
  final double    price;
  final int?      status;
  // ignore: non_constant_identifier_names
  final DateTime  created_at;

  // create contructor
  Product({
    this.id,
    required this.name,
    required this.price,
    this.status,
    // ignore: non_constant_identifier_names
    required this.created_at
  });


  factory Product.fromMap(Map<String, dynamic>json ) => Product(
    id:         json['id'],
    name:       json['name'], 
    price:      json['price'], 
    created_at: json['created_at'],
  );

  // create Map data
  Map<String, dynamic> toMap() {
    return {
      'id'         : id,
      'name'       : name,
      'price'      : price,
      'created_at' :created_at
    };
  }
}