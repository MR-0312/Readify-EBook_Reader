// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'pdf_viewer_screen.dart'; // Import your PDF viewer screen
// import 'epub_reader_screen.dart'; // Import your ePub reader screen

// class Book {
//   final String title;
//   final String author;
//   final String description;
//   final String fileUrl;
//   final String fileType;

//   Book({
//     required this.title,
//     required this.author,
//     required this.description,
//     required this.fileUrl,
//     required this.fileType,
//   });

//   factory Book.fromDocument(DocumentSnapshot doc) {
//     return Book(
//       title: doc['title'],
//       author: doc['author'],
//       description: doc['description'],
//       fileUrl: doc['file_url'],
//       fileType: doc['file_type'], // fileType: 'pdf' or 'epub'
//     );
//   }
// }

// class BooksListScreen extends StatelessWidget {
//   const BooksListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Ebook Reader'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('books').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           var books =
//               snapshot.data!.docs.map((doc) => Book.fromDocument(doc)).toList();

//           return ListView.builder(
//             itemCount: books.length,
//             itemBuilder: (context, index) {
//               var book = books[index];
//               return ListTile(
//                 title: Text(book.title),
//                 subtitle: Text(book.author),
//                 onTap: () {
//                   if (book.fileType == 'pdf') {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => PdfViewerScreen(book.fileUrl)),
//                     );
//                   } else if (book.fileType == 'epub') {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => EpubReaderScreen(book.fileUrl)),
//                     );
//                   }
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
