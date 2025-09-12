import 'package:flutter/material.dart';
import '../services/curated_books_service.dart';
import '../models/book_model.dart';
import '../services/google_books_service.dart';

/// Provider for managing curated books state
class CuratedBooksProvider with ChangeNotifier {
  final CuratedBooksService _curatedService = CuratedBooksService();
  final GoogleBooksService _googleService = GoogleBooksService();
  
  List<Map<String, dynamic>> _curatedBooks = [];
  List<BookModel> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<Map<String, dynamic>> get curatedBooks => _curatedBooks;
  List<BookModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  /// Load curated books
  Future<void> loadCuratedBooks() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _curatedBooks = _curatedService.getCuratedBooks();
    } catch (e) {
      _errorMessage = 'Erro ao carregar livros curados: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search books using Google Books API
  Future<void> searchBooks(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _searchResults = await _googleService.searchBooks(query);
    } catch (e) {
      _errorMessage = 'Erro ao buscar livros: $e';
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get books by subject
  Future<void> getBooksBySubject(String subject) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final bookNames = _curatedService.getBooksBySubject(subject);
      _searchResults = [];
      
      // Search each book by name
      for (final bookName in bookNames) {
        try {
          final results = await _googleService.searchBooks(bookName);
          _searchResults.addAll(results);
        } catch (e) {
          // Continue with other books if one fails
          continue;
        }
      }
    } catch (e) {
      _errorMessage = 'Erro ao buscar livros por disciplina: $e';
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}