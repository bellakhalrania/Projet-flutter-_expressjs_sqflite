import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Services/user_service.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final AuthService _authService = AuthService();
  List<dynamic>? _users;
  bool _loading = true;
  String? _errorMessage;
  String searchQuery = ''; // Variable pour la recherche

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final users = await _authService.getAllUsers();
    setState(() {
      _users = users;
      _loading = false;
      if (users == null) {
        _errorMessage = 'Failed to load users';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Champ de recherche sous forme de carte
          Stack(
            children: [
              // Image en arrière-plan
              Container(
                height: 120, // Hauteur de la zone du champ de recherche
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background2.jpg"), // Votre image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Carte du champ de recherche
              Positioned(
                top: 40, // Position verticale
                left: 16,
                right: 16,
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search users...',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Liste des utilisateurs
          _loading
              ? Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent, // Style du loader
              ),
            ),
          )
              : _errorMessage != null
              ? Expanded(
            child: Center(
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red, // Style pour les erreurs
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
              : Expanded(
            child: ListView.builder(
              itemCount: _users?.length ?? 0,
              itemBuilder: (context, index) {
                final user = _users![index];

                // Filtrage des utilisateurs en fonction de la recherche
                if (searchQuery.isNotEmpty &&
                    !user['name']
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase())) {
                  return Container(); // Masquer l'élément non correspondant
                }

                return Card(
                  margin: EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12.0),
                    leading: CircleAvatar(
                      child: Text(
                        user['name'][0], // Première lettre du nom
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.orange, // Couleur de l'avatar
                    ),
                    title: Text(
                      user['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    subtitle: Text(
                      user['email'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
