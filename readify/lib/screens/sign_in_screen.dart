// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:readify/screens/book_list_screen.dart';

// class SignInScreen extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   SignInScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign In')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             try {
//               await _auth.signInAnonymously();
//               Navigator.pushReplacement(
//                 // ignore: use_build_context_synchronously
//                 context,
//                 MaterialPageRoute(builder: (context) => const BooksListScreen()),
//               );
//             } catch (e) {
//               print(e);
//             }
//           },
//           child: const Text('Sign In Anonymously'),
//         ),
//       ),
//     );
//   }
// }
