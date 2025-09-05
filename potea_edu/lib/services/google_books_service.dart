import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

/// Serviço para integração com a API do Google Books
class GoogleBooksService {
  static const String _baseUrl = 'https://www.googleapis.com/books/v1';
  static const int _maxResults = 20;

  /// Busca livros por termo de pesquisa
  Future<List<BookModel>> searchBooks(String query, {int startIndex = 0}) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = '$_baseUrl/volumes?q=$encodedQuery&maxResults=$_maxResults&startIndex=$startIndex';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List items = data['items'] ?? [];
        
        return items.map((item) => BookModel.fromJson(item)).toList();
      } else {
        throw Exception('Falha ao carregar livros: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na conexão: $e');
    }
  }

  /// Busca livros por categoria/assunto
  Future<List<BookModel>> searchBooksBySubject(String subject, {int startIndex = 0}) async {
    return searchBooks('subject:$subject', startIndex: startIndex);
  }

  /// Busca livros acadêmicos/educacionais
  Future<List<BookModel>> searchEducationalBooks(String query, {int startIndex = 0}) async {
    final educationalQuery = '$query+intitle:education OR intitle:academic OR intitle:textbook';
    return searchBooks(educationalQuery, startIndex: startIndex);
  }

  /// Busca livros populares em uma categoria
  Future<List<BookModel>> getPopularBooks(String category) async {
    final queries = {
      'science': 'subject:science&orderBy=relevance',
      'mathematics': 'subject:mathematics&orderBy=relevance',
      'literature': 'subject:literature&orderBy=relevance',
      'history': 'subject:history&orderBy=relevance',
      'programming': 'programming+computer+science&orderBy=relevance',
      'fiction': 'subject:fiction&orderBy=relevance',
    };

    final query = queries[category.toLowerCase()] ?? 'subject:$category&orderBy=relevance';
    return searchBooks(query);
  }

  /// Obtém detalhes de um livro específico
  Future<BookModel?> getBookDetails(String bookId) async {
    try {
      final url = '$_baseUrl/volumes/$bookId';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return BookModel.fromJson(data);
      }
    } catch (e) {
      throw Exception('Erro ao carregar detalhes do livro: $e');
    }
    return null;
  }
}