// services/book_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/book_model.dart';


class BookService {
  static const String baseUrl = 'http://192.168.1.16:3000/api/books';

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
}
