import 'package:flutter/material.dart';
import 'screens/pages/home_page.dart';
// import 'package:order_manager/screens/layout/myapp.dart';

void main() {
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/homePage': (context) => const HomePage(),
        '/productPage': (context) => const HomePage(),
        '/orderPage': (context) => const HomePage(),
        '/statisticalPage': (context) => const HomePage(),
        '/add': (context) => const HomePage(),
        '/edit': (context) => const HomePage(),  
        '/editOrderPage': (context) => const HomePage(),
        // '/searchContactsByCategory': (context) =>SearchContactsByCategory()
      },
      home: const HomePage(),
    );
  }
}