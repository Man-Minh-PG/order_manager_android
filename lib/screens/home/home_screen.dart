import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/provider/order_service.dart';
import 'package:grocery_app/provider/product_service.dart';
import 'package:grocery_app/widgets/grocery_item_card_widget.dart';
import 'package:grocery_app/widgets/search_bar_widget.dart';
import 'package:grocery_app/models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchBarController = TextEditingController();

  String searchTerm = '';
  final ProductService productService = ProductService();

  List<Product> allProducts = [];
  List<Product> exclusiveOffers = [];
  List<Product> preOrders = [];
  List<Product> lstTopping = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
     loadData();
 
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    final data = await productService.getProducts();

    setState(() {
      allProducts = data;

      exclusiveOffers =
          allProducts.where((e) => e.category == 'exclusive').toList();

      preOrders =
          allProducts.where((e) => e.category == 'preorder').toList();

      lstTopping =
          allProducts.where((e) => e.category == 'topping').toList();

      isLoading = false;
    });
  }

  void updateSearchTerm(String value) {
    setState(() {
      searchTerm = value;
    });
  }

  void clearSearchBar() {
    _searchBarController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      padded(locationWidget()),
                      const SizedBox(height: 15),

                      padded(SearchBarWidget(
                        onSearchChanged: updateSearchTerm,
                        controller: _searchBarController,
                      )),

                      const SizedBox(height: 25),

                      padded(subTitle("Bánh")),
                      getHorizontalItemSlider(exclusiveOffers),

                      const SizedBox(height: 15),

                      padded(subTitle("Đơn Hàng")),
                      getHorizontalItemSlider(preOrders),

                      const SizedBox(height: 15),

                      padded(subTitle("Other")),
                      getHorizontalItemSlider(lstTopping),

                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          handleSubmitOrder();
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
    );
  }

  // ================= UI HELPERS =================

  Widget padded(Widget widget) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: widget,
    );
  }

  Widget subTitle(String text) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget locationWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/icons/icons8-keroppi.svg"),
        const SizedBox(width: 8),
        const Text(
          "Note here",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget getHorizontalItemSlider(List<Product> items) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return GroceryItemCardWidget(
            item: items[index],
            heroSuffix: "home_screen",
          );
        },
      ),
    );
  }

  // ================= ORDER HANDLER =================

  // void handleSubmitOrder() async {
  //   List<Product> selectedItems = [];

  //   selectedItems.addAll(
  //       exclusiveOffers.where((e) => e.orderQuantity > 0));

  //   selectedItems.addAll(
  //       preOrders.where((e) => e.orderQuantity > 0));

  //   selectedItems.addAll(
  //       lstTopping.where((e) => e.orderQuantity > 0));

  //   if (selectedItems.isEmpty) {
  //     showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //         title: const Text('Thông báo'),
  //         content: const Text('Bạn chưa chọn sản phẩm nào.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('Đóng'),
  //           ),
  //         ],
  //       ),
  //     );
  //     return;
  //   }

  //   OrderService orderService = OrderService();
  //   bool success = await orderService.createOrder(
  //     selectedItems,
  //     searchTerm,
  //   );

  //   if (success) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Đã tạo đơn hàng thành công!'),
  //       ),
  //     );

  //     setState(() {
  //       for (var item in allProducts) {
  //         item.orderQuantity = 0;
  //       }
  //       clearSearchBar();
  //     });
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Tạo đơn hàng thất bại!'),
  //       ),
  //     );
  //   }
  // }

  void handleSubmitOrder() async {
    List<Product> selectedItems = [];

    List<Product> allSelected = [
      ...exclusiveOffers,
      ...preOrders,
      ...lstTopping,
    ];

    for (var item in allSelected) {
      if (item.orderQuantity > 0) {
        selectedItems.add(
          Product(
            id: item.id,
            name: item.name,
            description: item.description,
            imagePath: item.imagePath,
            orderQuantity: item.orderQuantity,
            exclusiveOffers: item.exclusiveOffers,
            category: item.category,
            price: item.price * item.orderQuantity,
          ),
        );
      }
    }

    if (selectedItems.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Thông báo'),
          content: const Text('Bạn chưa chọn sản phẩm nào.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
      return;
    }

    OrderService orderService = OrderService();
    bool success = await orderService.createOrder(
      selectedItems,
      searchTerm,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã tạo đơn hàng thành công!'),
        ),
      );

      setState(() {
        for (var item in allProducts) {
          item.orderQuantity = 0;
        }
        clearSearchBar();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tạo đơn hàng thất bại!'),
        ),
      );
    }
  }
}