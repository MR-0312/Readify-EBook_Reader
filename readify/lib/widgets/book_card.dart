import 'package:flutter/material.dart';
import '../models/book.dart';
import '../screens/book_detail_screen.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final double width;
  final double height;
  final bool isDetailed;

  const BookCard({
    Key? key,
    required this.book,
    required this.width,
    required this.height,
    this.isDetailed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookDetailsScreen(book: book)),
      ),
      child: Container(
        width: width,
        height: height,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    book.coverImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              if (isDetailed)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        book.author,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}