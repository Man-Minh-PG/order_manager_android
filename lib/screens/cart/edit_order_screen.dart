import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/provider/order_service.dart';
import 'package:grocery_app/screens/product_details/product_details_screen.dart';
import 'package:grocery_app/widgets/grocery_item_card_widget.dart';
import 'package:grocery_app/widgets/search_bar_widget.dart';
import 'package:grocery_app/models/product_model.dart';

class EditOrderScreen extends StatefulWidget {
   final int orderId;

  EditOrderScreen({required this.orderId});

  @override
  _EditOrderScreenState createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}