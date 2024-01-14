/// Class product item
/// Set default value for first load
/// 
/// @author: minh_man
/// @since 2024-01-13
class ProductItem {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String imagePath;

  // Contructor class
  ProductItem({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath
  });
}

var demoItems = [
  ProductItem(
    id: 1,
    name: "Siêu phẩm", 
    description: "Phô Mai+Tứn+Chúi", 
    price: 30, 
    imagePath: ""),
  ProductItem(
    id: 2,
    name: "Phô mai chuối", 
    description: "Phô Mai+Chúi", 
    price: 27, 
    imagePath: ""),
  ProductItem(
    id: 3,
    name: "Phô mai trứng", 
    description: "Phô Mai+Tứn+Tứn", 
    price: 27, 
    imagePath: ""),
  ProductItem(
    id: 4,
    name: "Phô mai", 
    description: "Phô Mai", 
    price: 24, 
    imagePath: ""), 
  ProductItem(
    id: 6,
    name: "Trứng chúi", 
    description: "Tứn+Chúi", 
    price: 22, 
    imagePath: ""),
  ProductItem(
    id: 7,
    name: "Trứng Bắp", 
    description: "Phô Mai+Tứn+Chúi", 
    price: 22, 
    imagePath: ""),   
 ProductItem(
    id: 8,
    name: "Dừa", 
    description: "Phô Mai+Tứn+Chúi", 
    price: 22, 
    imagePath: ""),   
  ProductItem(
    id: 9,
    name: "Ca Cao", 
    description: "Phô Mai+Tứn+Chúi", 
    price: 17, 
    imagePath: ""), 
  ProductItem(
    id: 10,
    name: "Chúi/Trứng", 
    description: "Tứn/Chúi", 
    price: 20, 
    imagePath: ""),    
];