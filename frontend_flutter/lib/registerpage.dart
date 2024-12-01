import 'package:flutter/material.dart';
import 'package:frontend_flutter/user/userhome.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'user';

  // Fonction pour envoyer la requête d'enregistrement
  Future<void> registerUser() async {
    final url = 'http://192.168.1.16:3000/api/users/register'; // Remplacez par l'URL de votre API
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'role': _role,
      }),
    );

    if (response.statusCode == 201) {
      // Si l'utilisateur est créé avec succès
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(responseData['message']),
      ));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserScreen()),
      );
    } else {
      // Si une erreur survient
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(responseData['error']),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'assets/registration.png', // Remplacez par le chemin de votre image
              height: 200,
              width: 300,
            ),
            SizedBox(height: 50),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Container(
              width: 350,
              child: ElevatedButton(
                onPressed: registerUser,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // Change la couleur du texte du bouton
                  backgroundColor: Colors.grey, // Change la couleur du fond du bouton
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0), // Ajuste le padding du bouton
                ),
                child: Text('Register'),

              ),
            )



          ],
        ),
      ),
    );
  }
}
