import 'package:flutter/material.dart';
import 'package:flutterwebapi/screens/add_entry_screen.dart';
import 'package:flutterwebapi/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/add-entry': (context) => AddEntryScreen(),
      },
    );
  }
}
