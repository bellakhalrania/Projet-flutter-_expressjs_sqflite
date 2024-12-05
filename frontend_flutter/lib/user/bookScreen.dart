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

      body: FutureBuilder<List<Book>>(
        future: books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No books found.',
                style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            );
          }

          final filteredBooks = snapshot.data!
              .where((book) => book.title.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: filteredBooks.length,
            itemBuilder: (context, index) {
              final book = filteredBooks[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 19.0, horizontal: 16.0), // Légèrement augmenté
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 5.0, // Shadow effect for the card
                child: ListTile(
                  leading: book.image != null && book.image!.isNotEmpty
                      ? Container(
                    width: 100, // Largeur personnalisée
                    height: 150, // Hauteur personnalisée
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0), // Coins arrondis pour les images
                      child: CachedNetworkImage(
                        imageUrl: "http://172.25.240.1:3000/" + book.image!.replaceAll("\\", "/"),
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.broken_image),
                        fit: BoxFit.cover,
                        width: 150, // Largeur personnalisée
                        height: 150,// Ajuste l'image pour remplir l'espace
                      ),
                    ),
                  )
                      : Icon(
                    Icons.book,
                    size: 50,
                    color: Colors.grey,
                  ),
                  title: Text(
                    '${book.title} (ID: ${book.id})',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Author: ${book.author}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        'Year: ${book.year}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8.0), // Spacing between text and button
                      ElevatedButton(
                        onPressed: () async {
                          if (_userId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'User ID is not loaded. Please try again later.',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }
                          final String userId = _userId!;
                          bool success = await BorrowService.createBorrowRequest(book.id.toString(), userId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Borrow request sent successfully for "${book.title}".'
                                    : 'Failed to send borrow request for "${book.title}".',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: success ? Colors.green : Colors.red,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB67332),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        ),
                        child: Text(
                          'Borrow Book',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
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