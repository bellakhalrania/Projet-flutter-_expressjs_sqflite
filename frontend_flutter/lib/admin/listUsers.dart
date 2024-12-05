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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'User List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent, // Changer la couleur du titre
              ),
            ),
          ),
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
                        user['name'][0], // Affiche la première lettre
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.blueAccent, // Couleur de l'avatar
                    ),
                    title: Text(
                      user['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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