import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Models/book_model.dart';
import '../Services/book_service.dart';
import '../Services/borrow_service.dart';
class BookScreen extends StatefulWidget {
  final VoidCallback onRefresh; // Add the onRefresh parameter
  BookScreen({required this.onRefresh});
  @override
  _BookScreenState createState() => _BookScreenState();
}
class _BookScreenState extends State<BookScreen> {
  final _storage = const FlutterSecureStorage();
  String? _userName;
  String? _userId;
  late Future<List<Book>> books;
  String searchQuery = '';
  @override
  void initState() {
    super.initState();
    books = BookService.getBooks();
    _loadUserData();
  }
  Future<void> _fetchBooks() async {
    books = BookService.getBooks();
    setState(() {});
  }
  void _refreshBooks() {
    _fetchBooks();
  }
  Future<void> _loadUserData() async {
    final userName = await _storage.read(key: 'userName');
    final userId = await _storage.read(key: 'userId');
    setState(() {
      _userName = userName;
      _userId = userId;
    });
  }
  void _borrowBook(int bookId) {
    // Implement the logic to borrow the book, e.g., send a request to the server
    print('Borrowing book with ID: $bookId and User ID: $_userId');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You have borrowed the book with ID: $bookId and User ID: $_userId'),
        duration: Duration(seconds: 3),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      FutureBuilder<List<Book>>(
        future: books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No books found.'));
          }
          final filteredBooks = snapshot.data!
              .where((book) => book.title.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();
          return ListView.builder(
            itemCount: filteredBooks.length,
            itemBuilder: (context, index) {
              final book = filteredBooks[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: book.image != null && book.image!.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: "http://192.168.1.16:3000/" + book.image!.replaceAll("\\", "/"),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.broken_image),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : Icon(Icons.book),
                  title: Text('${book.title} (ID: ${book.id})'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Author: ${book.author}'),
                      Text('Year: ${book.year}'),
                      SizedBox(height: 8.0), // Add spacing between text and button
                      ElevatedButton(
                        onPressed: () async {
                          if (_userId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('User ID is not loaded. Please try again later.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return; // Stop if user ID is null
                          }
                          final String userId = _userId!; // Hardcoded for demo; replace with dynamic user ID
                          bool success = await BorrowService.createBorrowRequest(book.id.toString(), userId);
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Borrow request sent successfully for "${book.title}".'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to send borrow request for "${book.title}".'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB67332),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        ),
                        child: Text('Borrow Book'),
                      ),
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
}