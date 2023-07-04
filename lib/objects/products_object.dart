class Products {
  final int?      id;
  final String    name;
  final double    price;
  final int?       status;
  // ignore: non_constant_identifier_names
  final DateTime  created_at;

  // create contructor
  Products({
    this.id,
    required this.name,
    required this.price,
    this.status,
    // ignore: non_constant_identifier_names
    required this.created_at
  });


  factory Products.fromMap(Map<String, dynamic>json ) => Products(
    id:  json['id'],
    name: json['name'], 
    price: json['price'], 
    created_at: json['created_ats'],
  );

  // create Map data
  Map<String, dynamic> toMap() {
    return {
      'id'    : id,
      'name'  : name,
      'price' : price,
      
    };
  }
}