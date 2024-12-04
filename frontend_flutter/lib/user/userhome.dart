import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Models/book_model.dart';
import '../Services/book_service.dart';
import '../Services/borrow_service.dart';

class UserScreen extends StatefulWidget {
  final VoidCallback onRefresh; // Fonction callback pour rafraîchir les données

  UserScreen({required this.onRefresh});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<List<Book>> books;
  String searchQuery = '';

  final String currentUserId = "123"; // Remplacez par l'ID de l'utilisateur connecté

  @override
  void initState() {
    super.initState();
    books = BookService.getBooks(); // Charger les livres au démarrage
  }

  Future<void> _fetchBooks() async {
    books = BookService.getBooks(); // Recharger les livres
    setState(() {});
  }

  Future<void> _borrowBook(Book book) async {
    bool success = await BorrowService.createBorrowRequest(book.id.toString(), currentUserId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${book.title} borrowed successfully!')),
      );
      widget.onRefresh(); // Appeler la fonction de rafraîchissement après un prêt réussi
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to borrow ${book.title}. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrow Book'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchBooks, // Rafraîchir les livres
          ),
        ],
      ),
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

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search Books',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    final book = filteredBooks[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                        title: Text(book.title),
                        subtitle: Text(book.author),
                        trailing: ElevatedButton(
                          onPressed: () => _borrowBook(book),
                          child: Text('Borrow'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
