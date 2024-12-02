
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


import '../Models/book_model.dart';
import '../Services/book_service.dart';


class BookScreen extends StatefulWidget {

  final VoidCallback onRefresh; // Add the onRefresh parameter

  BookScreen({required this.onRefresh});

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
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


              );
            },
          );
        },
      ),
    );
  }
}