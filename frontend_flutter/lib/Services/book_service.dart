// services/book_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../Models/book_model.dart';

class BookService {
  static const String baseUrl = 'http://192.168.1.16:3000/api/books';

  // Obtenir tous les livres
  static Future<List<Book>> getBooks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((book) => Book.fromJson(book)).toList();
      } else {
        throw Exception('Failed to load books: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }

  // Ajouter un livre
  static Future<Book> addBook(Book book, XFile? imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(baseUrl),
      );

      // Add book data to the request
      request.fields['title'] = book.title;
      request.fields['author'] = book.author;
      request.fields['year'] = book.year.toString();

      // Add image if provided
      if (imageFile != null) {
        var image = await http.MultipartFile.fromPath('image', imageFile.path);
        request.files.add(image);
      }

      // Send the request
      var response = await request.send();

      if (response.statusCode == 201) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        return Book.fromJson(json.decode(responseString));
      } else {
        throw Exception('Failed to add book: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error adding book: $e');
    }
  }

  // Mettre à jour un livre
  // In BookService
  static Future<void> updateBook(Book book, XFile? imageFile) async {
    try {
      var request = http.MultipartRequest(
          'PUT',
          Uri.parse('$baseUrl/${book.id}')
      );

      // Add the book data to the request
      request.fields['title'] = book.title;
      request.fields['author'] = book.author;
      request.fields['year'] = book.year.toString();

      // Add the image to the request if a new image is selected
      if (imageFile != null) {
        var image = await http.MultipartFile.fromPath('image', imageFile.path);
        request.files.add(image);
      }

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        print("Book updated successfully.");
      } else {
        throw Exception('Failed to update book: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error updating book: $e');
    }
  }


  // Supprimer un livre
  static Future<void> deleteBook(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete book: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error deleting book: $e');
    }
  }
}
