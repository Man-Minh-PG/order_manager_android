import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/provider/order_service.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/widgets/grocery_item_card_widget.dart';
import 'package:grocery_app/widgets/search_bar_widget.dart';
import 'package:grocery_app/models/product_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<GroceryItem> selectedItems = [];
  String searchTerm = '';

  // Hàm callback để nhận giá trị tìm kiếm từ SearchBarWidget
  void updateSearchTerm(String value) {
    setState(() {
      searchTerm = value; // Cập nhật giá trị tìm kiếm
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  SvgPicture.asset("assets/icons/app_icon_color.svg"),
                  SizedBox(
                    height: 5,
                  ),
                  padded(locationWidget()),
                  SizedBox(
                    height: 15,
                  ),
                   padded(SearchBarWidget(
                    onSearchChanged: updateSearchTerm, // Truyền hàm callback vào SearchBarWidget
                  )),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  padded(subTitle("Bánh")),
                  getHorizontalItemSlider(exclusiveOffers), // Show list item1 
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            List<GroceryItem> selectedItems = exclusiveOffers.where((item) => item.orderQuantity > 0).toList();
            // onAddButtonSelected(selectedItems.first); // call to function process add to cart
            onAddButtonSelected(selectedItems); // call to function process add to cart
            // print(selectedItems);
          });
        }, 
        child: Text("Add")
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget padded(Widget widget) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: widget,
    );
  }

  Widget getHorizontalItemSlider(List<GroceryItem> items) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 500, // Set an appropriate height for your container
      child: SingleChildScrollView(
        child: Column(
          children: List.generate((items.length / 2).ceil(), (rowIndex) {
            int startIndex = rowIndex * 2;
            int endIndex = (rowIndex + 1) * 2;
            if (endIndex > items.length) {
              endIndex = items.length;
            }

            List<GroceryItem> rowItems = items.sublist(startIndex, endIndex);

            return Row(
              children: rowItems.map((item) {
                return Expanded(
                  child: GestureDetector(
                    child: GroceryItemCardWidget( // call to class - generate info product
                      item: item,
                      heroSuffix: "home_screen",
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ),
      ),
    );
  }

  void onItemClicked(BuildContext context, GroceryItem groceryItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          groceryItem,
          heroSuffix: "home_screen",
        ),
      ),
    );
  }

  Widget subTitle(String text) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Spacer(),
      ],
    );
  }

  Widget locationWidget() {
    String locationIconPath = "assets/icons/location_icon.svg"; 
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          locationIconPath,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          "Khartoum, Sudan",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
 
// Assuming the selected grocery_item is available as groceryItem
// void onAddButtonSelected(GroceryItem groceryItem) {
  void onAddButtonSelected(List<GroceryItem> groceryItem) {
      List<Product> selectedProducts = []; // Danh sách các sản phẩm đã chọn

      for (var item in groceryItem) {
        if(item.orderQuantity > 0) {
            Product product = Product( 
              id : item.id,
              description : item.description,
              imagePath: item.imagePath,
              orderQuantity: item.orderQuantity,
              name: item.name,
              price: item.price,
              exclusiveOffers: item.exclusiveOffers, // Set the exclusiveOffers value
            );
            
          selectedProducts.add(product); // Thêm sản phẩm vào danh sách đã chọn
        }
      }

     OrderService orderService = OrderService();
     orderService.createOrder(selectedProducts, searchTerm);
  }
}
