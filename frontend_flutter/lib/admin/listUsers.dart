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
      body:Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'User List',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          _loading
              ? Expanded(child: Center(child: CircularProgressIndicator()))
              : _errorMessage != null
              ? Expanded(child: Center(child: Text(_errorMessage!)))
              : Expanded(
            child: ListView.builder(
              itemCount: _users?.length ?? 0,
              itemBuilder: (context, index) {
                final user = _users![index];
                return ListTile(
                  title: Text(user['name']),
                  subtitle: Text(user['email']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}