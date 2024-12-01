import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../Models/book_model.dart';
import '../Services/book_service.dart';

class UpdateBookScreen extends StatefulWidget {
  final Book book;

  UpdateBookScreen({required this.book});

  @override
  _UpdateBookScreenState createState() => _UpdateBookScreenState();
}

class _UpdateBookScreenState extends State<UpdateBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    // Initialisation des contrôleurs avec les valeurs actuelles du livre
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _imageFile = null; // Pas d'image sélectionnée initialement
  }

  // Fonction pour sélectionner une nouvelle image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  // Fonction pour mettre à jour le livre
  void _updateBook() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Créer un objet Book avec les nouvelles valeurs
        Book updatedBook = Book(
          id: widget.book.id,  // Garder l'id original du livre
          title: _titleController.text,
          author: _authorController.text,
          year: widget.book.year,  // Garder l'année actuelle ou permettre sa modification
          image: _imageFile?.path, // Mettre à jour l'image si elle est sélectionnée
        );

        // Appeler le service pour mettre à jour le livre
        await BookService.updateBook(updatedBook, _imageFile);

        // Retourner à l'écran précédent après la mise à jour réussie
        Navigator.pop(context);
      } catch (e) {
        // Gérer les erreurs ici, comme afficher un message d'erreur
        print('Error updating book: $e');
      }
    }
  }



  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Champ pour le titre du livre
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              // Champ pour l'auteur du livre
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an author';
                  }
                  return null;
                },
              ),
              // Affichage de l'image actuelle ou sélection d'une nouvelle image
              GestureDetector(
                onTap: _pickImage,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: _imageFile == null
                      ? (widget.book.image != null && widget.book.image!.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: "http://192.168.1.16:3000/" + widget.book.image!.replaceAll("\\", "/"),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.broken_image),
                    height: 200,
                    width: 200,
                  )
                      : Icon(Icons.image, size: 100))
                      : Image.file(
                    File(_imageFile!.path),
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Bouton pour soumettre le formulaire
              ElevatedButton(
                onPressed: _updateBook,
                child: Text('Update Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
