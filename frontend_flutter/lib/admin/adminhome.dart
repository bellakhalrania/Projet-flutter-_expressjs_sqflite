import 'package:flutter/material.dart';

import '../views/homepage.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Interface")),
      body: Center(child: HomePage(),),
    );
  }
}
