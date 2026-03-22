class Product {
  int? id; // nullable để insert
  String name;
  String description;
  int price;
  String imagePath;
  int orderQuantity;
  bool exclusiveOffers;

  Product({
    this.id,
    required this.name,
    this.description = '',
    required this.price,
    this.imagePath = '',
    this.orderQuantity = 0,
    this.exclusiveOffers = false,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0) as int,
      imagePath: map['imagePath'] ?? '',
      orderQuantity: (map['orderQuantity'] ?? map['status'] ?? 0) as int,
      exclusiveOffers: (map['exclusiveOffers'] ?? 0) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
      'orderQuantity': orderQuantity,
      'exclusiveOffers': exclusiveOffers ? 1 : 0,
    };
  }
}