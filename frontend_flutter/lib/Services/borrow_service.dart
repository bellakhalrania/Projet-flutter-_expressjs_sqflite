// lib/services/borrow_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/borrowRequest.dart';


class BorrowService {
  // Remplacez par l'URL de votre serveur backend
  static const String _baseUrl = 'http://172.25.240.1:3000/api';

  /// Crée une demande d'emprunt
  static Future<bool> createBorrowRequest(String bookId, String userId) async {
    final url = Uri.parse('$_baseUrl/borrow');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'book_id': bookId,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 201) {
        // Demande créée avec succès
        return true;
      } else {
        // Erreur lors de la création de la demande
        print('Erreur: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  /// Récupère toutes les demandes d'emprunt (pour les administrateurs)
  static Future<List<BorrowRequest>> getAllBorrowRequests() async {
    final url = Uri.parse('$_baseUrl/borrow');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => BorrowRequest.fromJson(json)).toList();
      } else {
        print('Erreur: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exception: $e');
      return [];
    }
  }

  /// Met à jour le statut d'une demande d'emprunt
  static Future<bool> updateBorrowStatus(int id, String status) async {
    final url = Uri.parse('$_baseUrl/borrow/$id');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        // Statut mis à jour avec succès
        return true;
      } else {
        // Erreur lors de la mise à jour du statut
        print('Erreur: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  /// Récupère les livres empruntés par un utilisateur spécifique
  static Future<List<BorrowRequest>> getUserBorrowedBooks(String userId) async {
    final url = Uri.parse('$_baseUrl/borrow/user/$userId');  // Correct the URL
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((data) => BorrowRequest.fromJson(data)).toList();
      } else {
        print('Erreur: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exception: $e');
      return [];
    }
  }
}
