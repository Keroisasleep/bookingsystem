class Book {
  final String id;
  final String title;
  final String author;

  Book({required this.id, required this.title, required this.author});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'], // MongoDB uses _id
      title: json['title'],
      author: json['author'],
    );
  }
}
