import 'package:flutter/material.dart';
import 'package:grocery_app/models/grocery_item.dart'; // Load default item
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
// import 'package:grocery_app/styles/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/widgets/grocery_item_card_widget.dart';
import 'package:grocery_app/widgets/search_bar_widget.dart';

// import 'grocery_featured_Item_widget.dart';
// import 'home_banner_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// class HomeScreen extends StatelessWidget {
class _HomeScreenState extends State<HomeScreen> {
  List<GroceryItem> selectedItems = [];

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
                  padded(SearchBarWidget()), // Khung search
                  SizedBox(
                    height: 25,
                  ),
                  // padded(HomeBanner()),
                  SizedBox(
                    height: 25,
                  ),
                  padded(subTitle("Bánh")),
                  getHorizontalItemSlider(exclusiveOffers), // Show list item1 
                  SizedBox(
                    height: 15,
                  ),
                  padded(subTitle("Món thêm")),
                  getHorizontalItemSlider(bestSelling), // Show list item2
                  SizedBox(
                    height: 15,
                  ),
                  // padded(subTitle("Groceries")), // manu sp khac
                  SizedBox(
                    height: 15,
                  ),
                  // Add button order
                  ElevatedButton(
                    onPressed: () {
                    // Lọc danh sách các sản phẩm có orderQuantity > 0
                      setState(() {
                        List<GroceryItem> selectedItems = demoItems
                      .where((item) => item.orderQuantity > 0)
                      .toList();
                      });
                    }, 
                    child: Text("Add to cart")
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget padded(Widget widget) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: widget,
    );
  }

  Widget getHorizontalItemSlider(List<GroceryItem> items) { // Function get list product
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 250,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              onItemClicked(context, items[index]);
            },
            child: GroceryItemCardWidget(
              item: items[index],
              heroSuffix: "home_screen",
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 20,
          );
        },
      ),
    );
  }

  void onItemClicked(BuildContext context, GroceryItem groceryItem) { // Function on click -> pagination data to screen product detail
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(
                groceryItem,
                heroSuffix: "home_screen",
              )),
    );
  }

  Widget subTitle(String text) { // Funtion show infomation text order
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        // Text(
        //   "See All",
        //   style: TextStyle(
        //       fontSize: 18,
        //       fontWeight: FontWeight.bold,
        //       color: AppColors.primaryColor),
        // ),
      ],
    );
  }

  Widget locationWidget() { // Funtion show location data
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
          "Khartoum,Sudan",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

}
