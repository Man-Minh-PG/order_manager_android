class GroceryItem {
  final int id;
  final String name;
  final String description;
  final int price;
  final String imagePath;
  late  int orderQuantity;
  final bool exclusiveOffers;

  GroceryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.orderQuantity,
    required this.exclusiveOffers
  });

}

var demoItems = [
  GroceryItem(
      id: 1,
      name: "Sieu_Pham",
      description: "7pcs, Priceg",
      price: 30,
      imagePath: "assets/images/grocery_images/banana.png", orderQuantity: 0, exclusiveOffers: false),
  GroceryItem(
      id: 2,
      name: "PM_Chui",
      description: "1kg, Priceg",
      price: 27,
      imagePath: "assets/images/grocery_images/apple.png", orderQuantity: 0, exclusiveOffers: false),
  GroceryItem(
      id: 3,
      name: "PM_Trung",
      description: "1kg, Priceg",
      price: 27,
      imagePath: "assets/images/grocery_images/pepper.png", orderQuantity: 0, exclusiveOffers: false),
  GroceryItem(
      id: 4,
      name: "PM",
      description: "250gm, Priceg",
      price: 24,
      imagePath: "assets/images/grocery_images/ginger.png", orderQuantity: 0, exclusiveOffers: false),
  GroceryItem(
      id: 5,
      name: "TC",
      description: "250gm, Priceg",
      price: 22,
      imagePath: "assets/images/grocery_images/beef.png", orderQuantity: 0, exclusiveOffers: false),
  GroceryItem(
      id: 6,
      name: "TB",
      description: "250gm, Priceg",
      price: 22,
      imagePath: "assets/images/grocery_images/chicken.png", orderQuantity: 0, exclusiveOffers: false),
];

var exclusiveOffers = [demoItems[0], demoItems[1],demoItems[3], demoItems[4] ];

var bestSelling = [demoItems[2], demoItems[3]];

var groceries = [demoItems[4], demoItems[5]];

var beverages = [
  GroceryItem(
      id: 7,
      name: "Dite Coke",
      description: "355ml, Price",
      price: 1,
      imagePath: "assets/images/beverages_images/diet_coke.png", orderQuantity: 0, exclusiveOffers: false),
  GroceryItem(
      id: 8,
      name: "Sprite Can",
      description: "325ml, Price",
      price: 1,
      imagePath: "assets/images/beverages_images/sprite.png", orderQuantity: 0, exclusiveOffers: false),
  GroceryItem(
      id: 8,
      name: "Apple Juice",
      description: "2L, Price",
      price: 15,
      imagePath: "assets/images/beverages_images/apple_and_grape_juice.png", orderQuantity: 0, exclusiveOffers: false),
  GroceryItem(
      id: 9,
      name: "Orange Juice",
      description: "2L, Price",
      price: 10,
      imagePath: "assets/images/beverages_images/orange_juice.png", orderQuantity: 0, exclusiveOffers: false),
  GroceryItem(
      id: 10,
      name: "Coca Cola Can",
      description: "325ml, Price",
      price: 4,
      imagePath: "assets/images/beverages_images/coca_cola.png", orderQuantity: 0, exclusiveOffers: false),
  GroceryItem(
      id: 11,
      name: "Pepsi Can",
      description: "330ml, Price",
      price: 4,
      imagePath: "assets/images/beverages_images/pepsi.png", orderQuantity: 0, exclusiveOffers: false),
];
