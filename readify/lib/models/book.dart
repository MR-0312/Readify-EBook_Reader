class Book {
  final String title;
  final String author;
  final String coverImage;
  final String description;
  final String published;
  final String fileName; // Add this

  Book({
    required this.title,
    required this.author,
    required this.coverImage,
    required this.description,
    required this.published,
    required this.fileName, // Add this
  });
}
