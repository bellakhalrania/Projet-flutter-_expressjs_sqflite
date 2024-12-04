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

  // Fonction pour effectuer le login
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
        // Fonction de rafraîchissement à passer dans UserScreen
        void onRefresh() {
          print("Books list refreshed");
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserScreen(onRefresh: onRefresh)),
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
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 200,
              width: 300,
              child: Icon(
                Icons.lock_person_sharp,
                size: 200,
                color: Colors.brown,
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
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                ),
                child: Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
