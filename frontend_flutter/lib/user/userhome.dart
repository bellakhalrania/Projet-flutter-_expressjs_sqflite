import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Interface")),
      body: Center(child: Text("Welcome, User!")),
    );
  }
}
