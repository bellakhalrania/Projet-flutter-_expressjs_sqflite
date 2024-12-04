import 'package:flutter/material.dart';
import '../Services/user_service.dart';
import '../welcomescreen.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final AuthService _authService = AuthService();
  String? _userName;
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userName = await _authService.getUserName();
    final role = await _authService.getRole();
    setState(() {
      _userName = userName ?? 'Unknown User';
      _role = role ?? 'No Role Assigned';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white70,
              Color(0xFFB67332) // Utilisez 0xFF pour spécifier un code hexadécimal
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centre verticalement
          crossAxisAlignment: CrossAxisAlignment.center, // Centre horizontalement
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Text(
                _userName != null && _userName!.isNotEmpty
                    ? _userName![0].toUpperCase()
                    : '?',
                style: TextStyle(fontSize: 40, color: Colors.blueAccent),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _userName ?? 'Unknown User',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              _role ?? 'No Role Assigned',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _authService.logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blueAccent, backgroundColor: Colors.white, // Texte bleu
              ),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
