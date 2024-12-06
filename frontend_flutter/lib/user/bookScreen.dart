import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Models/book_model.dart';
import '../Services/book_service.dart';
import '../Services/borrow_service.dart';

class BookScreen extends StatefulWidget {
  final VoidCallback onRefresh; // Parameter for refreshing
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

  Future<void> _loadUserData() async {
    final userName = await _storage.read(key: 'userName');
    final userId = await _storage.read(key: 'userId');
    setState(() {
      _userName = userName;
      _userId = userId;
    });
  }

  Future<void> _borrowBook(int bookId) async {
    if (_userId != null) {
      final success = await BorrowService.createBorrowRequest(bookId.toString(), _userId!);

      if (success) {
        // Show SnackBar if the borrowing was successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You have borrowed the book with ID: $bookId'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // Show error message if borrowing failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to borrow the book with ID: $bookId. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      // If the user is not logged in, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please log in to borrow a book.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
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
                  fontSize: 15.0,
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

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: filteredBooks.length,
            itemBuilder: (context, index) {
              final book = filteredBooks[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 5.0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Image
                      book.image != null && book.image!.isNotEmpty
                          ? Container(
                        width: double.infinity,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                          child: CachedNetworkImage(
                            imageUrl: "http://192.168.56.1:3000/" + book.image!.replaceAll("\\", "/"),
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.broken_image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                          : Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                          color: Colors.grey[300],
                        ),
                        child: Icon(
                          Icons.book,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                      // Title
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${book.title}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Subtitle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
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
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0),
                      // Borrow Button
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            // Show confirmation dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Borrowing'),
                                  content: Text('Are you sure you want to borrow "${book.title}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close the dialog
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _borrowBook(book.id); // Call the method to borrow the book
                                        Navigator.of(context).pop(); // Close the dialog
                                      },
                                      child: Text('Confirm'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFB67332),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                          ),
                          child: Text(
                            'Borrow Book',
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
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