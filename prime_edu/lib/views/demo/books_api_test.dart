import 'package:flutter/material.dart';
import 'package:prime_edu/services/google_books_service.dart';
import 'package:prime_edu/models/book_model.dart';

class BooksApiTestScreen extends StatefulWidget {
  const BooksApiTestScreen({super.key});

  @override
  State<BooksApiTestScreen> createState() => _BooksApiTestScreenState();
}

class _BooksApiTestScreenState extends State<BooksApiTestScreen> {
  final GoogleBooksService _booksService = GoogleBooksService();
  List<BookModel> _books = [];
  bool _isLoading = false;
  String _error = '';

  Future<void> _testSearch() async {
    setState(() {
      _isLoading = true;
      _error = '';
      _books = [];
    });

    try {
      final books = await _booksService.searchBooks('mathematics');
      setState(() {
        _books = books;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teste Google Books API')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _testSearch,
              child: const Text('Buscar Livros de Matemática'),
            ),
            const SizedBox(height: 16),
            if (_isLoading) const CircularProgressIndicator(),
            if (_error.isNotEmpty)
              Text('Erro: $_error', style: const TextStyle(color: Colors.red)),
            if (_books.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    final book = _books[index];
                    return Card(
                      child: ListTile(
                        title: Text(book.title),
                        subtitle: Text(book.authorsString),
                        trailing: Text(book.publishYear),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
