import 'package:flutter/foundation.dart';
import '../models/book_model.dart';
import '../services/book_download_service.dart';

/// Provider para gerenciar downloads de livros
class BookDownloadProvider extends ChangeNotifier {
  final BookDownloadService _downloadService = BookDownloadService();

  // Estado dos downloads
  final Map<String, double> _downloadProgress = {};
  final Set<String> _downloadedBooks = {};

  // Getters
  Map<String, double> get downloadProgress =>
      Map.unmodifiable(_downloadProgress);
  Set<String> get downloadedBooks => Set.unmodifiable(_downloadedBooks);

  bool isBookDownloaded(String bookId) => _downloadedBooks.contains(bookId);
  double? getDownloadProgress(String bookId) => _downloadProgress[bookId];

  /// Inicia o download de um livro
  Future<bool> downloadBook(BookModel book) async {
    try {
      // Se já está baixado, retorna sucesso
      if (isBookDownloaded(book.id)) {
        return true;
      }

      // Se já está em download, não inicia novamente
      if (_downloadProgress.containsKey(book.id)) {
        return false;
      }

      // Inicia o download
      final result = await _downloadService.downloadBookPDF(
        book,
        onProgress: (progress) {
          _downloadProgress[book.id] = progress;
          notifyListeners();
        },
        onError: (error) {
          _downloadProgress.remove(book.id);
          notifyListeners();
        },
      );

      if (result) {
        _downloadedBooks.add(book.id);
        _downloadProgress.remove(book.id);
        notifyListeners();
      } else {
        _downloadProgress.remove(book.id);
        notifyListeners();
      }

      return result;
    } catch (e) {
      _downloadProgress.remove(book.id);
      notifyListeners();
      return false;
    }
  }

  /// Remove um livro baixado
  Future<bool> removeDownloadedBook(String bookId) async {
    try {
      final result = await _downloadService.removeDownloadedBook(bookId);
      if (result) {
        _downloadedBooks.remove(bookId);
        notifyListeners();
      }
      return result;
    } catch (e) {
      return false;
    }
  }

  /// Obtém o caminho do PDF baixado
  Future<String?> getBookPDFPath(String bookId) async {
    return await _downloadService.getBookPDFPath(bookId);
  }

  /// Obtém o tamanho estimado do arquivo
  String getEstimatedFileSize(BookModel book) {
    return _downloadService.getEstimatedFileSize(book);
  }
}
