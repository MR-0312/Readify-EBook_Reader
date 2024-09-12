import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerScreen extends StatelessWidget {
  final String fileUrl;

  const PdfViewerScreen(this.fileUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read Book'),
      ),
      body: PDFView(
        filePath: fileUrl,
      ),
    );
  }
}
