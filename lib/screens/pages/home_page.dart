/*
  * This screen for ordering products

  Submit data to validation flutter
  https://blog.logrocket.com/flutter-form-validation-complete-guide/
*/
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OrderScreen(),
    );
  }  
}

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState(); 
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  String equation          = "0";
  String result            = "0";
  String expression        = "";
  int quantity             = 0;
  final quantityController = TextEditingController();

  @override 
  Widget build(BuildContext context) {

    _processCaculator() {
      this.setState(() {
        quantity++;
      });
    }
     final listTiles = <Widget> [
      const Divider(),
      ListTile(
        leading  : Icon(Icons.face),
        title    : Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Product 1'),
            Text(quantity.toString())
          ],
        ), // hoi chat gpt lam sao de o cho nay mot doan text = number khi onclick thi tang len
        subtitle : Text('Price'),
        trailing : ElevatedButton(
          onPressed: _processCaculator(), 
          child: const Text('+')
        ),// o day la buton 
      ),

    // Item two
    ListTile(
        leading  : Icon(Icons.face),
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

            Container(
              child: ListView(children: listTiles),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child:  ElevatedButton(
                onPressed: _processCaculator(), 
                child: Text('Add')
              ),// o day
            )
          ],
        ),
      ),
    );
    
  }
}