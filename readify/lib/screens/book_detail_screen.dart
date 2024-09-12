import 'package:flutter/material.dart';
import 'epub_reader_screen.dart';
import '../models/book.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(book.coverImage, height: 200),
            const SizedBox(height: 20),
            Text(
              book.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text('Author: ${book.author}'),
            Text('Published: ${book.published}'),
            const SizedBox(height: 20),
            Text(book.description),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EpubReaderScreen(
                        filePath:
                            'assets/${book.fileName}', // Assuming book file is stored in assets
                        title: book.title,
                      ),
                    ),
                  );
                },
                child: const Text('Read'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
