
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend_flutter/views/updatebook.dart';

import '../Models/book_model.dart';
import '../Services/book_service.dart';
import 'addbook.dart';

class BookListScreen extends StatefulWidget {

  final VoidCallback onRefresh; // Add the onRefresh parameter

  BookListScreen({required this.onRefresh});

  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> books;
  String searchQuery = '';


  @override
  void initState() {
    super.initState();
    books = BookService.getBooks();
  }

  Future<void> _fetchBooks() async {
    books = BookService.getBooks();
    setState(() {});
  }

  void _refreshBooks() {
    _fetchBooks();
  }

  void deleteBook(int bookId) async {
    try {
      await BookService.deleteBook(bookId);
      _refreshBooks(); // Refresh the list after deletion
    } catch (e) {
      print('Error deleting book: $e');
    }
  }

  void updateBook(Book book) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateBookScreen(
        book: book,
        onBookAdded: _refreshBooks,
      ),
      ),
    );
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder<List<Book>>(
        future: books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent, // Couleur du loader
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.redAccent, // Couleur des messages d'erreur
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No books found.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
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
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 3, // Ombre légère
                child: ListTile(
                  contentPadding: EdgeInsets.all(12.0),
                  leading: book.image != null && book.image!.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: "http://172.25.240.1:3000/" + book.image!.replaceAll("\\", "/"),
                      placeholder: (context, url) => CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                      ),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Icon(Icons.book, size: 50, color: Colors.grey),
                  title: Text(
                    book.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  subtitle: Text(
                    book.author,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.green), // Icône de modification stylée
                        onPressed: () {
                          updateBook(book);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red), // Icône de suppression rouge
                        onPressed: () {
                          deleteBook(book.id);
                        },
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