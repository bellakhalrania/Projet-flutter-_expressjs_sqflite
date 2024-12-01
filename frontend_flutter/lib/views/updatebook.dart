import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../Models/book_model.dart';
import '../Services/book_service.dart';

class UpdateBookScreen extends StatefulWidget {
  final VoidCallback onBookAdded;
  final Book book;

  UpdateBookScreen({required this.book, required this.onBookAdded});

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
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _imageFile = null; // No image selected initially
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  void _updateBook() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Determine image path: use the new image if selected, otherwise keep the existing image URL
        String? imagePath = _imageFile?.path ?? widget.book.image;

        Book updatedBook = Book(
          id: widget.book.id, // Keep the original book ID
          title: _titleController.text,
          author: _authorController.text,
          year: widget.book.year, // Keep the current year or allow modification
          image: imagePath, // Update the image if selected, otherwise use the existing image
        );

        // Call the service to update the book
        await BookService.updateBook(updatedBook, _imageFile);

        // Call the callback to refresh the book list
        widget.onBookAdded();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Book updated successfully!')),
        );

        // Navigate back after successful update
        Navigator.pop(context);
      } catch (e) {
        print('Error updating book: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating book: $e')),
        );
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