import 'package:flutter/material.dart';
import 'package:grocery_app/screens/cart/cart_screen.dart';
import 'package:grocery_app/screens/explore_screen.dart';
import 'package:grocery_app/screens/home/home_screen.dart';
import 'package:grocery_app/screens/payment_history/payment_history_screen.dart';
import '../favourite_screen.dart';

class NavigatorItem {
  final String label;
  final String iconPath;
  final int index;
  final Widget screen;

  NavigatorItem(this.label, this.iconPath, this.index, this.screen);
}

List<NavigatorItem> navigatorItems = [
  NavigatorItem("Home", "assets/icons/shop_icon.svg", 0, HomeScreen()),
  NavigatorItem("Order", "assets/icons/cart_icon.svg", 1, CartScreen()),
  NavigatorItem("History", "assets/icons/explore_icon.svg", 2, ExploreScreen()),

  NavigatorItem(
      "Report", "assets/icons/favourite_icon.svg", 3, FavouriteScreen()),
  NavigatorItem("Money", "assets/icons/money_icon.svg", 4, PaymentHistoryScreen()),
];
