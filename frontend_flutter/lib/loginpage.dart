import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/user/userhome.dart';

import 'Services/user_service.dart';
import 'admin/adminhome.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final success = await _authService.login(email, password);
    if (success) {
      final role = await _authService.getRole();
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminScreen()),
        );
      } else if (role == 'user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserScreen(onRefresh: () {})),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid login credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login",
          style:   TextStyle(fontSize: 24.0, // Taille de la police
              fontWeight: FontWeight.bold, // Poids de la police (facultatif)
              color: Colors.brown,))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 200,
              width: 300,
              child: Icon(
                Icons.lock_person_sharp,
                size: 200, // Adjust size
                color: Colors.brown, // Change color if needed
              ),
            ),
            SizedBox(height: 50),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,

            ),
            SizedBox(height: 16),
        Container(
          width: 350,
            child: ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, // Change la couleur du texte du bouton
                backgroundColor: Colors.grey, // Change la couleur du fond du bouton
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0), // Ajuste le padding du bouton
              ),
              child: Text("Login"),
            ),
          )
          ],
        ),
      ),
    );
  }
}
