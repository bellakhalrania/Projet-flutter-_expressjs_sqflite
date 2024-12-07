import 'package:flutter/material.dart';
import 'package:frontend_flutter/views/listbook.dart';
import 'package:frontend_flutter/views/addbook.dart';

import '../Services/user_service.dart';
import '../admin/listUsers.dart';
import '../welcomescreen.dart';

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
  Future<void> _logout() async {
    // Logique de déconnexion via AuthService (à adapter selon votre service)
    await AuthService().logout(); // Déconnecter l'utilisateur
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
    );// Rediriger vers l'écran de connexion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome Admin",
          style: TextStyle(
            fontWeight: FontWeight.bold, // Gras
            color: Colors.white,
            fontSize: 25,
            fontFamily: 'DMSerifText', // Nom de la police configurée dans pubspec.yaml
          ),
        ),
        backgroundColor: Color(0xFFB67332),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFB67332),
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Books'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Book'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.person_pin),
              title: Text('Users'),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            // Ajout du bouton de déconnexion
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.black),
              title: Text('Logout'),
              onTap: () {
                // Affiche une boîte de dialogue pour confirmer la déconnexion
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmation'),
                      content: Text('Are you sure you want to logout?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Ferme le dialogue sans action
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            _logout(); // Appelle la méthode _logout pour procéder à la déconnexion
                            Navigator.pop(context); // Ferme le dialogue
                          },
                          child: Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

          ],
        ),
      ),
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
            label: 'Users',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}