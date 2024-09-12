import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import '../utils/book_data.dart'; // Import the book list

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Split the list into two categories if needed
    final List<Book> bestOfTheDay = books.sublist(0, 2); // First two books
    final List<Book> continueReading = books.sublist(2); // Remaining books

    return Scaffold(
      appBar: AppBar(
        title: const Text('What are you reading today?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Best of the day',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    bestOfTheDay.map((book) => BookCard(book: book)).toList(),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Continue reading...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.builder(
                itemCount: continueReading.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      3, // Change this based on your layout preference
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return BookCard(book: continueReading[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
