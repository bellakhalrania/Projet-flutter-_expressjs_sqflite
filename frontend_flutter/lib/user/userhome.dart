import 'package:flutter/material.dart';
import 'bookScreen.dart';


class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int _selectedIndex = 0;

  late List<Widget> _screens; // Declare screens list

  @override
  void initState() {
    super.initState();
    _screens = [
      BookScreen(onRefresh: _refreshBooks),
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