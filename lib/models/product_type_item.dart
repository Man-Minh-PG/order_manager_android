// Class product type default - test first load
class ProductTypeItem {
  final int? id;
  final String name;
  final String imagePath;

  // Contructor Product Type Item
  ProductTypeItem({
    this.id,
    required this.name,
    required this.imagePath
  });


  var productTypeItem = [
    ProductTypeItem(
      name: "Bánh chúi", 
      imagePath: "assets/images/categories_images/fruit.png",
    ),
     ProductTypeItem(
      name: "Món thêm", 
       imagePath: "assets/images/categories_images/bakery.png",
    ),
  ];
}