import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/provider/product_service.dart';

class ProductManagementScreen extends StatefulWidget {
  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final ProductService productService = ProductService();
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    products = await productService.getProducts();
    setState(() => isLoading = false);
  }

  void _showEditDialog(Product product) {
    final controller = TextEditingController(text: product.price.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Sửa giá"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Giá mới"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Hủy")),
          ElevatedButton(
            onPressed: () async {
              product.price = int.parse(controller.text);
              await productService.updateProduct(product);
              Navigator.pop(context);
              fetchProducts();
            },
            child: Text("Lưu"),
          )
        ],
      ),
    );
  }

  Widget _buildItem(Product product) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Giá: ${product.price}K"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditDialog(product),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await productService.deleteProduct(product.id!);
                fetchProducts();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addProduct() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();

    String selectedCategory = 'exclusive'; // default

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text("Thêm sản phẩm"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Tên"),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: "Giá"),
                  keyboardType: TextInputType.number,
                ),

                SizedBox(height: 10),

                // Dropdown category
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(labelText: "Category"),
                  items: const [
                    DropdownMenuItem(value: 'exclusive', child: Text('Product')),
                    DropdownMenuItem(value: 'preorder', child: Text('App')),
                    DropdownMenuItem(value: 'topping', child: Text('Topping')),
                  ],
                  onChanged: (value) {
                    setStateDialog(() {
                      selectedCategory = value!;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Hủy"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isEmpty || priceController.text.isEmpty) return;

                  await productService.insertProduct(
                    Product(
                      name: nameController.text,
                      price: int.parse(priceController.text),
                      category: selectedCategory,
                    ),
                  );

                  Navigator.pop(context);
                  fetchProducts();
                },
                child: Text("Thêm"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý sản phẩm"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchProducts,
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (_, i) => _buildItem(products[i]),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
      ),
    );
  }
}