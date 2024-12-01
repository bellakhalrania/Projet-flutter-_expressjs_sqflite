class Book {
  final int id;
  final String title;
  final String author;
  final int year;
  final String? image;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
    this.image,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      year: json['year'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'year': year,
      'image': image,
    };
  }
}