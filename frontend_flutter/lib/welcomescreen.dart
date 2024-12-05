import 'package:flutter/material.dart';
import 'package:frontend_flutter/registerpage.dart';
import 'loginpage.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE5D4), Color(0xFFB67332)], // Dégradé personnalisé
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Titre de bienvenue
              Text(
                "Welcome to My Library",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB67332), // Texte en couleur principale
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Image
              Image.asset(
                'assets/background.jpg', // Remplacez par le chemin de votre image
                height: 250,
                width: 400,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 40), // Espace entre l'image et les boutons
              // Bouton Login
              Container(
                width: 300, // Largeur du bouton
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, // Couleur du texte
                    backgroundColor: Color(0xFFB67332), // Couleur principale
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Bords arrondis
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.0), // Padding
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 20), // Espace entre les boutons
              // Bouton Register
              Container(
                width: 300, // Largeur du bouton
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, // Couleur du texte
                    backgroundColor: Color(0xFFB67332), // Couleur principale
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Bords arrondis
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.0), // Padding
                  ),
                  child: Text(
                    "Register",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
