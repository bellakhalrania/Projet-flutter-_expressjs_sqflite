
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
      body: Column(
        children: [
          // Champ de recherche sous forme de carte
          Stack(
            children: [
              // Image en arrière-plan
              Container(
                height: 120, // Hauteur de la zone du champ de recherche
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background2.jpg"), // Remplacez par votre image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Carte du champ de recherche
              Positioned(
                top: 40, // Ajustez la position verticale si nécessaire
                left: 16,
                right: 16,
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search books...',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Liste des livres
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: books,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.redAccent,
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

                // Filtrage des livres
                final filteredBooks = snapshot.data!
                    .where((book) => book.title
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
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
                      elevation: 3,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12.0),
                        leading: book.image != null && book.image!.isNotEmpty
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: "http://192.168.56.1:3000/" +
                                book.image!.replaceAll("\\", "/"),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(strokeWidth: 2.0),
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
                              icon: Icon(Icons.edit, color: Colors.green),
                              onPressed: () {
                                updateBook(book);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Affiche la boîte de dialogue de confirmation
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirmation"),
                                      content: Text("Are you sure you want to delete this book?"),
                                      actions: <Widget>[
                                        // Bouton Annuler
                                        TextButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            // Fermer la boîte de dialogue sans supprimer
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        // Bouton Supprimer
                                        TextButton(
                                          child: Text("Delete", style: TextStyle(color: Colors.red)),
                                          onPressed: () {
                                            // Supprimer le livre
                                            deleteBook(book.id);
                                            // Fermer la boîte de dialogue après suppression
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            )

                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}