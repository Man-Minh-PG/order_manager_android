import 'package:grocery_app/models/order_model.dart';
import 'package:grocery_app/models/product_model.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/repository/order_repository.dart'; // Import the order repository

class OrderService {
  final OrderRepository _orderRepository = OrderRepository();

  Future<void> addProductToOrder(Order order, GroceryItem groceryItem) async {
    // Set the exclusiveOffers value for the product based on the predefined value in the GroceryItem class
    Product product = Product(
      id : groceryItem.id,
      description: groceryItem.description,
      imagePath: groceryItem.imagePath,
      orderQuantity: groceryItem.orderQuantity,
      name: groceryItem.name,
      price: groceryItem.price,
      exclusiveOffers: groceryItem.exclusiveOffers, // Set the exclusiveOffers value
    );

    // Logic to add the product to the order and insert into the detail table
    // For example:
    order.products.add(product); // Add the product to the order
    await _orderRepository.insertOrderDetail(order.id, product.id); // Insert into the detail table
  }
}