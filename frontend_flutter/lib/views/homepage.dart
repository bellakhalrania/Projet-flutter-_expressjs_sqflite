import 'package:flutter/material.dart';
import 'package:frontend_flutter/views/listbook.dart';
import 'package:frontend_flutter/views/addbook.dart';

import '../admin/listUsers.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late List<Widget> _screens; // Declare screens list

  @override
  void initState() {
    super.initState();
    _screens = [
      BookListScreen(onRefresh: _refreshBooks), // Pass the onRefresh callback
      AddBookScreen(onBookAdded: _refreshBooks),
      UserListPage(),
    ];
  }

  void _refreshBooks() {
    setState(() {
      // Refresh logic if necessary
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome Admin")),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Book',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            label: 'users',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}