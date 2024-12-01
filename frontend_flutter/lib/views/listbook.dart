
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
      MaterialPageRoute(builder: (context) => UpdateBookScreen(book: book)),
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
              return ListTile(
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
                title: Text(book.title),
                subtitle: Text(book.author),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min, // To fit the icons nicely
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit), // Update icon
                      onPressed: () {
                        updateBook(book);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteBook(book.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}