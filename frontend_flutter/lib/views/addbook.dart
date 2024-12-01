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
        Navigator.pop(context);
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
      appBar: AppBar(
        title: Text('Add Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
                onSaved: (value) => title = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an author.';
                  }
                  return null;
                },
                onSaved: (value) => author = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a year.';
                  }
                  // Check if the input can be parsed to an integer
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid year.';
                  }
                  return null;
                },
                onSaved: (value) => year = int.parse(value!), // Ensure this line is safe now
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              if (imageFile != null)
                Image.file(
                  File(imageFile!.path),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Add Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}