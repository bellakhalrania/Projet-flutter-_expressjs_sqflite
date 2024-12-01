import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/registerpage.dart';

import 'loginpage.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrer verticalement
          crossAxisAlignment: CrossAxisAlignment.center, // Centrer horizontalement
          children: [
            // Image en haut
            Image.asset(
              'assets/background.jpg', // Remplacez par le chemin de votre image
              height: 300,
              width: 350,
            ),
            SizedBox(height: 50), // Espacement entre l'image et les boutons
            // Bouton "Entrer"
          Container(
            width: 350, // Modifie la largeur du bouton
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black87, // Change la couleur du texte du bouton
                backgroundColor: Colors.grey, // Change la couleur du fond du bouton
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0), // Ajuste le padding du bouton
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 25, // Taille de la police du texte
                ),
              ),
            ),
          ),

          SizedBox(height: 20), // Espacement entre les deux boutons
            // Bouton "Register"
            Container(
              width: 350, // Définir la largeur du bouton
              child: ElevatedButton(
                onPressed: () {
                  // Action pour le bouton "Register"
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // Change la couleur du texte du bouton
                  backgroundColor: Colors.brown, // Change la couleur du fond du bouton
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0), // Ajuste le padding du bouton
                ),
                child: Text("Register",style: TextStyle(fontSize: 25),),
              ),
            )

          ],
        ),
      ),
    );
  }
}