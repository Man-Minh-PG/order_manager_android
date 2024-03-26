import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:grocery_app/screens/welcome_screen.dart';
// import 'package:grocery_app/styles/colors.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:grocery_app/screens/home/home_screen.dart';

import 'dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    const delay = const Duration(seconds: 3);
    Future.delayed(delay, () => onTimerFinished());
  }

  void onTimerFinished() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
      builder: (BuildContext context) {
        // return WelcomeScreen();
        return DashboardScreen();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.primaryColor, // SET COLOR BACKGROUND
      backgroundColor: Color.fromARGB(255, 140, 137, 240), // SET COLOR BACKGROUND
      body: Center(
        child: splashScreenIcon(),
      ),
    );
  }
}

// Widget splashScreenIcon() {
//   // String iconPath = "assets/images/1.png";
//   String iconPath = "assets/icons/splash_screen_icon.svg";
//   return SvgPicture.asset(
//     iconPath,
//   );
// }
Widget splashScreenIcon() {
  String iconPath = "assets/images/flashscreen.png";
  return Image.asset(
    iconPath,
    // Bạn cũng có thể đặt chiều rộng và chiều cao cho hình ảnh theo nhu cầu của bạn.
    // width: 100,
    // height: 100,
  );
}
