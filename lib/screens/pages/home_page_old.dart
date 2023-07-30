/*
  * This screen for ordering products

  Submit data to validation flutter
  https://blog.logrocket.com/flutter-form-validation-complete-guide/
*/
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const OrderScreen(),
    );
  }  
}

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrderScreenState createState() => _OrderScreenState(); 
}

class _OrderScreenState extends State<OrderScreen> {
  String equation          = "0";
  String result            = "0";
  String expression        = "";
  int quantity             = 0;
  final quantityController = TextEditingController();

  @override 
  Widget build(BuildContext context) {

    // ignore: no_leading_underscores_for_local_identifiers
    _processCaculator() {
      setState(() {
        quantity++;
      });
    }
     final listTiles = <Widget> [
      const Divider(),
      ListTile(
        leading  : const Icon(Icons.face),
        title    : Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Product 1'),
            Text(quantity.toString())
          ],
        ), // hoi chat gpt lam sao de o cho nay mot doan text = number khi onclick thi tang len
        subtitle : const Text('Price'),
        trailing : ElevatedButton(
          onPressed: _processCaculator(), 
          child: const Text('+')
        ),// o day la buton 
      ),

    // Item two
    ListTile(
        leading  : const Icon(Icons.face),
        title    : Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Product 2'),
            Text(quantity.toString())
          ],
        ), // hoi chat gpt lam sao de o cho nay mot doan text = number khi onclick thi tang len
        subtitle : const Text('Price'),
        trailing : ElevatedButton(
          onPressed: _processCaculator(), 
          child: const Text('+')
        ),// o day la buton 
      ),

    ]; 
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            ListView(children: listTiles),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child:  ElevatedButton(
                onPressed: _processCaculator(), 
                child: const Text('Add')
              ),// o day
            )
          ],
        ),
      ),
    );
    
  }
}