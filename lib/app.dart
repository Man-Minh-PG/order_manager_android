import 'package:flutter/material.dart';
import 'package:grocery_app/screens/splash_screen.dart';
import 'package:grocery_app/styles/theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      // theme: ThemeData(
      //   scaffoldBackgroundColor: Colors.white, // Set background color to white
      // ),
      home: SplashScreen(),
    );
  }
}
