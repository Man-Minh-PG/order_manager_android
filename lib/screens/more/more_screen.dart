import 'package:flutter/material.dart';
import 'package:grocery_app/screens/more/create_transaction_screen.dart';
import 'package:grocery_app/screens/more/product_management_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  Widget _buildItem(BuildContext context, IconData icon, String title, Widget screen) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepOrange),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildItem(context, Icons.add_circle_outline, "Add Bill", CreateTransactionScreen()),
          _buildItem(context, Icons.inventory_2_outlined, "Bachutha edit", ProductManagementScreen()),
          // _buildItem(context, Icons.invert_colors_sharp, "Check bill", ProductManagementScreen()),
          // _buildItem(context, Icons.invert_colors_sharp, "Reset", ProductManagementScreen()),
        ],
      ),
    );
  }
}