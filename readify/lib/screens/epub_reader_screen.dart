import 'package:flutter/material.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';

class EpubReaderScreen extends StatefulWidget {
  final String filePath;
  final String title;

  const EpubReaderScreen({Key? key, required this.filePath, required this.title}) : super(key: key);

  @override
  _EpubReaderScreenState createState() => _EpubReaderScreenState();
}

class _EpubReaderScreenState extends State<EpubReaderScreen> {
  late Future<void> _initFuture;
  late EpubBook _epubBook;
  late SharedPreferences _prefs;
  final FlutterTts _flutterTts = FlutterTts();

  List<int> _bookmarks = [];
  String _theme = 'light';
  double _fontSize = 16.0;
  int _currentChapter = 0;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeReader();
  }

  Future<void> _initializeReader() async {
    _prefs = await SharedPreferences.getInstance();
    final bytes = await DefaultAssetBundle.of(context).load(widget.filePath);
    _epubBook = await EpubReader.readBook(bytes.buffer.asUint8List());
    _loadSettings();
    await _initTextToSpeech();
  }

  Future<void> _initTextToSpeech() async {
    await _flutterTts.setLanguage("en-IN");
    await _flutterTts.setSpeechRate(1.0);
    await _flutterTts.setPitch(1.0);
  }

  void _loadSettings() {
    _bookmarks = _prefs.getStringList('bookmarks_${widget.title}')?.map(int.parse).toList() ?? [];
    _theme = _prefs.getString('theme') ?? 'light';
    _fontSize = _prefs.getDouble('fontSize') ?? 16.0;
    _currentChapter = _prefs.getInt('currentChapter_${widget.title}') ?? 0;
  }

  Future<void> _saveSettings() async {
    await _prefs.setStringList('bookmarks_${widget.title}', _bookmarks.map((e) => e.toString()).toList());
    await _prefs.setString('theme', _theme);
    await _prefs.setDouble('fontSize', _fontSize);
    await _prefs.setInt('currentChapter_${widget.title}', _currentChapter);
  }

  void _toggleBookmark() {
    setState(() {
      if (_bookmarks.contains(_currentChapter)) {
        _bookmarks.remove(_currentChapter);
      } else {
        _bookmarks.add(_currentChapter);
      }
      _saveSettings();
    });
  }

  Future<void> _toggleTextToSpeech() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
    } else {
      final text = _epubBook.Chapters![_currentChapter].HtmlContent ?? '';
      final plainText = text.replaceAll(RegExp(r'<[^>]*>'), '');
      await _flutterTts.speak(plainText);
    }
    setState(() => _isSpeaking = !_isSpeaking);
  }

  void _nextChapter() {
    if (_currentChapter < (_epubBook.Chapters?.length ?? 1) - 1) {
      setState(() {
        _currentChapter++;
        _saveSettings();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return Theme(
          data: _getThemeData(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              actions: [
                IconButton(icon: Icon(_isSpeaking ? Icons.volume_up : Icons.volume_off), onPressed: _toggleTextToSpeech),
                IconButton(icon: Icon(_bookmarks.contains(_currentChapter) ? Icons.bookmark : Icons.bookmark_border), onPressed: _toggleBookmark),
                IconButton(icon: const Icon(Icons.settings), onPressed: _showSettingsSheet),
              ],
            ),
            drawer: Drawer(child: _buildChapterList()),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Html(
                    data: _epubBook.Chapters![_currentChapter].HtmlContent ?? 'No content available',
                    style: {'body': Style(fontSize: FontSize(_fontSize), color: _getTextColor())},
                  ),
                  ElevatedButton(
                    onPressed: _nextChapter,
                    child: Text('Next Chapter'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ThemeData _getThemeData() => _theme == 'dark'
      ? ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black87)
      : _theme == 'sepia'
          ? ThemeData.light().copyWith(scaffoldBackgroundColor: Color(0xFFF1E7D0))
          : ThemeData.light();

  Color _getTextColor() => _theme == 'dark' ? Colors.white : (_theme == 'sepia' ? Colors.brown[800]! : Colors.black87);

  Widget _buildChapterList() {
    return ListView.builder(
      itemCount: _epubBook.Chapters?.length ?? 0,
      itemBuilder: (context, index) {
        final chapter = _epubBook.Chapters![index];
        return ListTile(
          title: Text(
            chapter.Title ?? 'Chapter ${index + 1}',
            style: TextStyle(fontWeight: index == _currentChapter ? FontWeight.bold : FontWeight.normal),
          ),
          onTap: () {
            setState(() => _currentChapter = index);
            _saveSettings();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Reader Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['light', 'dark', 'sepia'].map((t) => ElevatedButton(
                onPressed: () {
                  setState(() => _theme = t);
                  _saveSettings();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: _theme == t ? Colors.blue : null),
                child: Text(t[0].toUpperCase() + t.substring(1)),
              )).toList(),
            ),
            SizedBox(height: 20),
            Text('Font Size'),
            Slider(
              value: _fontSize,
              min: 12,
              max: 24,
              divisions: 6,
              label: _fontSize.round().toString(),
              onChanged: (value) {
                setState(() => _fontSize = value);
                _saveSettings();
              },
            ),
          ],
        ),
      ),
    );
  }
}