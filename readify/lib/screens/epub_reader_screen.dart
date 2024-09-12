import 'package:flutter/material.dart';
import 'package:epubx/epubx.dart';

class EpubReaderScreen extends StatefulWidget {
  final String filePath;
  final String title;

  const EpubReaderScreen({super.key, required this.filePath, required this.title});

  @override
  _EpubReaderScreenState createState() => _EpubReaderScreenState();
}

class _EpubReaderScreenState extends State<EpubReaderScreen> {
  late EpubBook epubBook;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadEpub();
  }

  Future<void> _loadEpub() async {
    try {
      final bytes = await DefaultAssetBundle.of(context).load(widget.filePath);
      epubBook = await EpubReader.readBook(bytes.buffer.asUint8List());
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load ePub';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: epubBook.Chapters!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title:
                          Text(epubBook.Chapters![index].Title ?? 'No title'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChapterScreen(
                                chapter: epubBook.Chapters![index]),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

class ChapterScreen extends StatelessWidget {
  final EpubChapter chapter;

  const ChapterScreen({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chapter.Title ?? 'Chapter'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chapter.Title ?? 'No title',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(parseHtmlContent(
                chapter.HtmlContent ?? 'No content available')),
          ],
        ),
      ),
    );
  }

  String parseHtmlContent(String htmlContent) {
    // Replace <br> tags with newlines for better readability
    return htmlContent
        .replaceAll('<br>', '\n')
        .replaceAll('<br/>', '\n')
        .replaceAll('<br />', '\n');
  }
}
