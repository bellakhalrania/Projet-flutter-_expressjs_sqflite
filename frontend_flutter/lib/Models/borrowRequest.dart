class BorrowRequest {
  final int id;
  final String title;
  final String author;
  final String status;
  final String requestDate;

  BorrowRequest({
    required this.id,
    required this.title,
    required this.author,
    required this.status,
    required this.requestDate,
  });

  factory BorrowRequest.fromJson(Map<String, dynamic> json) {
    return BorrowRequest(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      status: json['status'],
      requestDate: json['request_date'],
    );
  }
}
