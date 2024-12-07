import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Models/book_model.dart';
import '../Services/book_service.dart';

class AddBookScreen extends StatefulWidget {
  final VoidCallback onBookAdded; // Callback to refresh the list

  AddBookScreen({required this.onBookAdded});

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String author = '';
  int year = 2021; // Default year
  XFile? imageFile; // Use XFile to hold the image

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile; // Save the selected image file
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        Book newBook = Book(id: 0, title: title, author: author, year: year);
        print('Adding book with title: $title, author: $author, year: $year');

        await BookService.addBook(newBook, imageFile);
        widget.onBookAdded();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Book added successfully!')),
        );
       // Navigator.pop(context);
      } catch (e) {
        print('Error adding book: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add book: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(  // Ajouté pour éviter les débordements
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0),

                    child: Text(
                      'Add New Book',  // Titre
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,  // Centrer le texte
                    ),
                  ),
                  SizedBox(height: 30),
                  // Image d'arrière-plan avec une bordure et un effet d'ombre
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                    ),
                    child: Image.asset(
                      'assets/background2.jpg', // Remplacez par le chemin de votre image
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 30), // Espacement ajusté

                  // Champ Title
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(color: Color(0xFFB67332), fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFB67332), width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFB67332), width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a title.';
                      }
                      return null;
                    },
                    onSaved: (value) => title = value!,
                  ),
                  SizedBox(height: 20),

                  // Champ Author
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Author',
                      labelStyle: TextStyle(color: Color(0xFFB67332), fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFB67332), width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFB67332), width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an author.';
                      }
                      return null;
                    },
                    onSaved: (value) => author = value!,
                  ),
                  SizedBox(height: 20),

                  // Champ Year
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Year',
                      labelStyle: TextStyle(color: Color(0xFFB67332), fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFB67332), width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFB67332), width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a year.';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid year.';
                      }
                      return null;
                    },
                    onSaved: (value) => year = int.parse(value!),
                  ),
                  SizedBox(height: 20),

                  // Bouton pour choisir une image
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB67332),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    ),
                    child: Text('Pick Image', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),

                  // Affichage de l'image choisie avec un cadre stylisé
                  if (imageFile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(imageFile!.path),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  SizedBox(height: 20),

                  // Bouton pour ajouter le livre
                  ElevatedButton(
                    onPressed: _submit,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB67332),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    ),
                    child: Text('Add Book', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        )

    );
  }
}