import 'package:flutter/material.dart';
import 'package:grocery_app/helpers/database.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init database trước khi chạy app
  await DatabaseRepository.instance.initDatabase();

  runApp(MyApp());
}