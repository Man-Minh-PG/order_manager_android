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
      description: "PM-TR-C",
      price: 30,
      imagePath: "assets/images/grocery_images/premium.png", orderQuantity: 0, exclusiveOffers: false),
  GroceryItem(
      id: 2,
      name: "PM_Chui",
      description: "PM-C",
      price: 27,
      imagePath: "assets/images/grocery_images/cheese.png", orderQuantity: 0, exclusiveOffers: false),
  GroceryItem(
      id: 3,
      name: "PM_Trung",
      description: "PM_Trung",
      price: 27,
      imagePath: "assets/images/grocery_images/cheese.png", orderQuantity: 0, exclusiveOffers: false),
   GroceryItem(
      id: 4,
      name: "PM_Bap",
      description: "PM_Bap",
      price: 27,
      imagePath: "assets/images/grocery_images/cheese.png", orderQuantity: 0, exclusiveOffers: false),
  GroceryItem(
      id: 5,
      name: "Pho_Mai",
      description: "Pho Mai",
      price: 24,
      imagePath: "assets/images/grocery_images/cheese.png", orderQuantity: 0, exclusiveOffers: false),
  GroceryItem(
      id: 6,
      name: "Tr_Chui",
      description: "TR + C",
      price: 22,
      imagePath: "assets/images/grocery_images/egg.jpg", orderQuantity: 0, exclusiveOffers: false),
  GroceryItem(
      id: 7,
      name: "Tr_Bap",
      description: "TR + Bap",
      price: 22,
      imagePath: "assets/images/grocery_images/egg.jpg", orderQuantity: 0, exclusiveOffers: false),
    GroceryItem(
      id: 8,
      name: "Chui",
      description: "C",
      price: 20,
      imagePath: "assets/images/grocery_images/banana.png", orderQuantity: 0, exclusiveOffers: false),
    GroceryItem(
      id: 9,
      name: "Trung",
      description: "TR",
      price: 20,
      imagePath: "assets/images/grocery_images/egg.jpg", orderQuantity: 0, exclusiveOffers: false),
    GroceryItem(
      id: 10,
      name: "Ca_Cao",
      description: "CC",
      price: 17,
      imagePath: "assets/images/grocery_images/cacao.jpg", orderQuantity: 0, exclusiveOffers: false),
    GroceryItem(
      id: 11,
      name: "Pho_Mai_them",
      description: "Topping +",
      price: 8,
      imagePath: "assets/images/grocery_images/cheese.png", orderQuantity: 0, exclusiveOffers: false),
     GroceryItem(
      id: 12,
      name: "Khac",
      description: "Topping +",
      price: 8,
      imagePath: "assets/images/grocery_images/banana.png", orderQuantity: 0, exclusiveOffers: false),
];

var exclusiveOffers = [demoItems[0], demoItems[1], demoItems[2],demoItems[3], demoItems[4], demoItems[5], demoItems[6], demoItems[7], demoItems[8], demoItems[9], demoItems[10], demoItems[11] ];

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
