import 'package:flutter/material.dart';
import 'package:frontend_flutter/views/homepage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}