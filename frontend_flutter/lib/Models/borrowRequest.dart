// lib/models/borrow_request.dart

class BorrowRequest {
  final int id;
  final String bookTitle;
  final String userName;
  final String status;
  final String requestDate;

  BorrowRequest({
    required this.id,
    required this.bookTitle,
    required this.userName,
    required this.status,
    required this.requestDate,
  });

  factory BorrowRequest.fromJson(Map<String, dynamic> json) {
    return BorrowRequest(
      id: json['id'],
      bookTitle: json['title'],
      userName: json['name'],
      status: json['status'],
      requestDate: json['request_date'],
    );
  }
}
