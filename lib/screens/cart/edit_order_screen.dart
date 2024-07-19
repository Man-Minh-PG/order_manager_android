/*
Class extends from home screen
*/ 

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/provider/order_service.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/widgets/grocery_item_card_widget.dart';
import 'package:grocery_app/widgets/search_bar_widget.dart';
import 'package:grocery_app/models/product_model.dart';

import '../dashboard/dashboard_screen.dart';

class EditOrderScreen extends StatefulWidget {
  final int orderId;

  EditOrderScreen({required this.orderId});

  @override
  _EditOrderScreenState createState() => _EditOrderScreenState(this.orderId);
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  TextEditingController _searchBarController = TextEditingController(); // Tạo controller
  final OrderService orderService = OrderService();
  List<GroceryItem> listProduct = exclusiveOffers;
  List<int> orderDetailId = [];
  late int orderId;

  List<GroceryItem> selectedItems = [];
  String searchTerm = '';

  // Hàm callback để nhận giá trị tìm kiếm từ SearchBarWidget
  void updateSearchTerm(String value) {
    setState(() {
      searchTerm = value; // Cập nhật giá trị tìm kiếm
    });
  }

  void clearSearchBar() {
    setState(() {
      _searchBarController.clear(); 
    });
  }

   _EditOrderScreenState(this.orderId);

 Future<void> fetchOrder() async {
  List<Map<String, dynamic>> orderDetails = await orderService.selectOrderWithID(orderId);
  setState(() {
    for (var orderDetail in orderDetails) {
      int productId = orderDetail['productId'] - 1;
      orderDetailId.add(orderDetail['orderDetailId']);

      if (productId >= 0 && productId < listProduct.length) {
        // Kiểm tra xem productId có trong listProduct không
        // ignore: unrelated_type_equality_checks
        if (listProduct[productId] != 0) {
          setState(() {
            listProduct[productId].orderQuantity = orderDetail['amount'];
          });
        }
      }
    }
  });
}
  @override
  void initState() {
    super.initState();
    fetchOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color.fromARGB(255, 248, 232, 220), // Màu be sữa đậm
          //  color: Color.fromARGB(255, 160, 39, 140), // Đổi màu nền ở đây
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  // SvgPicture.asset("assets/icons/icons8-morty-smith.svg"),
                  SizedBox(
                    height: 5,
                  ),
                  padded(locationWidget()),
                  SizedBox(
                    height: 15,
                  ),
                   padded(SearchBarWidget(
                    onSearchChanged: updateSearchTerm, // Truyền hàm callback vào SearchBarWidget
                    controller: _searchBarController, // Gọi biến sử dụng giữa 2 class 
                  )),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  padded(subTitle("EDIT Order")),
                  getHorizontalItemSlider(listProduct), // Show list item1 
                  SizedBox(
                    height: 15,
                  ),

                  padded(subTitle("Đơn Hàng")),
                  getHorizontalItemSlider(preOrders), // Show list pre order
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
        backgroundColor: Color.fromARGB(255, 156, 127, 29),
        foregroundColor: Colors.black, 
      onPressed: () {
        setState(() {
          // Lấy danh sách các sản phẩm được chọn
          List<GroceryItem> selectedItems = exclusiveOffers.where((item) => item.orderQuantity > 0).toList();
          List<GroceryItem> preOrderItems = preOrders.where((item) => item.orderQuantity > 0).toList();
          if (selectedItems.isNotEmpty) {
            // Gọi hàm xử lý khi nút được nhấn, truyền vào danh sách các sản phẩm đã chọn
            onAddButtonSelected(selectedItems); 

            // Đặt tất cả các giá trị orderQuantity về 0 cho các sản phẩm trong exclusiveOffers
            for (var item in exclusiveOffers) {
              item.orderQuantity = 0;
            }
          }else if(preOrderItems.isNotEmpty){
            // Gọi hàm xử lý khi nút được nhấn, truyền vào danh sách các sản phẩm đã chọn
            onAddButtonSelected(preOrderItems); 

            // Đặt tất cả các giá trị orderQuantity về 0 cho các sản phẩm trong exclusiveOffers
            for (var item in preOrderItems) {
              item.orderQuantity = 0;
            }
          }
          else {
            // Nếu không có dữ liệu, bạn có thể hiển thị một thông báo hoặc thực hiện một hành động khác ở đây
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Thông báo'),
                content: Text('Bạn chưa chọn sản phẩm nào.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Đóng'),
                  ),
                ],
              ),
            );
          }
        });
      }, 
     // child: Text("Edit")
      child: Icon(
        Icons.edit,
        color: Colors.white,
      )
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
      // height: 500, // Set an appropriate height for your container
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: items.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            // onTap: () => onItemClicked(context, items[index]),
            child: GroceryItemCardWidget(
              item: items[index],
              heroSuffix: "edit_screen",
            ),
          );
        },
      ),
      // child: SingleChildScrollView(
      //   child: Column(
      //     children: List.generate((items.length / 2).ceil(), (rowIndex) {
      //       int startIndex = rowIndex * 2;
      //       int endIndex = (rowIndex + 1) * 2;
      //       if (endIndex > items.length) {
      //         endIndex = items.length;
      //       }

      //       List<GroceryItem> rowItems = items.sublist(startIndex, endIndex);

      //       return Row(
      //         children: rowItems.map((item) {
      //           return Expanded(
      //             child: GestureDetector(
      //               child: GroceryItemCardWidget( // call to class - generate info product
      //                 item: item,
      //                 heroSuffix: "home_screen",
      //               ),
      //             ),
      //           );
      //         }).toList(),
      //       );
      //     }),
      //   ),
      // ),
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
    String locationIconPath = "assets/icons/icons8-morty-smith.svg"; 
    // assets/icons/icons8-morty-smith.svg
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
          "Note here",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
 
// Assuming the selected grocery_item is available as groceryItem
// void onAddButtonSelected(GroceryItem groceryItem) {
    void onAddButtonSelected(List<GroceryItem> groceryItem) async {
      List<Product> selectedProducts = []; // Danh sách các sản phẩm đã chọn

      for (var item in groceryItem) {
        if(item.orderQuantity > 0) {
          Product product = Product( 
            id : item.id,
            description : item.description,
            imagePath: item.imagePath,
            orderQuantity: item.orderQuantity,
            name: item.name,
            price: (item.price *item.orderQuantity),
            exclusiveOffers: item.exclusiveOffers, // Set the exclusiveOffers value
          );
          
          selectedProducts.add(product); // Thêm sản phẩm vào danh sách đã chọn
        }
      }

      OrderService orderService = OrderService();
      bool success = await orderService.editOrder(selectedProducts, searchTerm, orderDetailId); // Chờ cho hàm createOrder hoàn thành
      
      if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã edit thành công!'),
            ),
          );

          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen()),
          );

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('EditOrder thất bại!'),
            ),
          );
        }
    }

}
