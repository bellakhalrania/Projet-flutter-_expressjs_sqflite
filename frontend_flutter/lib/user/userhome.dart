import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'bookScreen.dart';
import 'borrowscreen.dart';
class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}
class _UserScreenState extends State<UserScreen> {
  final _storage = const FlutterSecureStorage();
  String? _userName;
  String? _userId;
  int _selectedIndex = 0;
  late List<Widget> _screens; // Declare screens list
  @override
  void initState() {
    super.initState();
    _screens = [
      BookScreen(onRefresh: _refreshBooks),
      BorrowScreen(),
    ];
    _loadUserData(); // Load user data on init
  }

  // Function to load user data
  Future<void> _loadUserData() async {
    final userName = await _storage.read(key: 'userName');
    final userId = await _storage.read(key: 'userId');
    setState(() {
      _userName = userName;
      _userId = userId;
    });
  }
  void _refreshBooks() {
    setState(() {
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
      appBar: AppBar(title: Text("Welcome user")),
      body: Column(
        children: [
          // Display user information
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.grey.shade200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User Name: ${_userName ?? 'Loading...'}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "User ID: ${_userId ?? 'Loading...'}",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          // Display the selected screen
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'borrowed book',
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