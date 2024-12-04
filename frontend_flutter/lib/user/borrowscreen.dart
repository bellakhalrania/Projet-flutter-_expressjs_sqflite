import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Models/borrowRequest.dart';
import '../Services/borrow_service.dart';

class BorrowScreen extends StatefulWidget {
  @override
  _BorrowScreenState createState() => _BorrowScreenState();
}

class _BorrowScreenState extends State<BorrowScreen> {
  final _storage = const FlutterSecureStorage();
  String? _userId;
  late Future<List<BorrowRequest>> borrowedBooks;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = await _storage.read(key: 'userId');
    setState(() {
      _userId = userId;
    });

    if (userId != null) {
      borrowedBooks = BorrowService.getUserBorrowedBooks(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrowed Books'),
      ),
      body: _userId == null
          ? Center(child: Text('User not logged in'))
          : FutureBuilder<List<BorrowRequest>>(
        future: borrowedBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No borrowed books found.'));
          }

          final books = snapshot.data!;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: Icon(Icons.book),
                  title: Text(book.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Author: ${book.author}'),
                      Text(
                        'Status: ${book.status}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(book.status), // Dynamically change color based on status
                        ),
                      ),


                      Text('Request Date: ${book.requestDate}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green; // Green for accepted status
      case 'pending':
        return Colors.orange; // Orange for pending status
      case 'refused':
        return Colors.red; // Red for refused status
      default:
        return Colors.black; // Default color
    }
  }
}
