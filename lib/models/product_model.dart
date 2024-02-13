class Product {
  int id;
  String name;
  String description;
  int price;
  String imagePath;
  int orderQuantity;
  bool exclusiveOffers; // Define the exclusiveOffers parameter

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.orderQuantity,
    required this.exclusiveOffers
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      imagePath: map['imagePath'],
      orderQuantity: map['status'],
      exclusiveOffers: map['exclusiveOffers'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
      'status': orderQuantity,
      'exclusiveOffers': exclusiveOffers,
    };
  }

}