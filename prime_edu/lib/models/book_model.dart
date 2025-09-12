/// Modelo de dados para representar um livro da API do Google Books
class BookModel {
  final String id;
  final String title;
  final List<String> authors;
  final String? description;
  final String? thumbnail;
  final String? publishedDate;
  final String? publisher;
  final int? pageCount;
  final List<String> categories;
  final double? averageRating;
  final int? ratingsCount;
  final String? previewLink;
  final String? infoLink;
  final String? language;
  final String? isbn10;
  final String? isbn13;

  BookModel({
    required this.id,
    required this.title,
    required this.authors,
    this.description,
    this.thumbnail,
    this.publishedDate,
    this.publisher,
    this.pageCount,
    required this.categories,
    this.averageRating,
    this.ratingsCount,
    this.previewLink,
    this.infoLink,
    this.language,
    this.isbn10,
    this.isbn13,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    final industryIdentifiers = volumeInfo['industryIdentifiers'] as List? ?? [];

    // Extrair ISBN
    String? isbn10;
    String? isbn13;
    for (var identifier in industryIdentifiers) {
      if (identifier['type'] == 'ISBN_10') {
        isbn10 = identifier['identifier'];
      } else if (identifier['type'] == 'ISBN_13') {
        isbn13 = identifier['identifier'];
      }
    }

    return BookModel(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'Título não disponível',
      authors: List<String>.from(volumeInfo['authors'] ?? ['Autor desconhecido']),
      description: volumeInfo['description'],
      thumbnail: imageLinks['thumbnail']?.replaceAll('http:', 'https:'), // Garantir HTTPS
      publishedDate: volumeInfo['publishedDate'],
      publisher: volumeInfo['publisher'],
      pageCount: volumeInfo['pageCount'],
      categories: List<String>.from(volumeInfo['categories'] ?? []),
      averageRating: volumeInfo['averageRating']?.toDouble(),
      ratingsCount: volumeInfo['ratingsCount'],
      previewLink: volumeInfo['previewLink'],
      infoLink: volumeInfo['infoLink'],
      language: volumeInfo['language'] ?? 'pt',
      isbn10: isbn10,
      isbn13: isbn13,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'description': description,
      'thumbnail': thumbnail,
      'publishedDate': publishedDate,
      'publisher': publisher,
      'pageCount': pageCount,
      'categories': categories,
      'averageRating': averageRating,
      'ratingsCount': ratingsCount,
      'previewLink': previewLink,
      'infoLink': infoLink,
      'language': language,
      'isbn10': isbn10,
      'isbn13': isbn13,
    };
  }

  /// Retorna uma string formatada com os autores
  String get authorsString {
    if (authors.isEmpty) return 'Autor desconhecido';
    if (authors.length == 1) return authors.first;
    if (authors.length == 2) return '${authors[0]} e ${authors[1]}';
    return '${authors[0]} e outros';
  }

  /// Retorna uma string formatada com as categorias
  String get categoriesString {
    if (categories.isEmpty) return 'Sem categoria';
    return categories.take(2).join(', ');
  }

  /// Retorna o ano de publicação
  String get publishYear {
    if (publishedDate == null) return 'Ano desconhecido';
    return publishedDate!.split('-').first;
  }

  /// Indica se o livro tem uma boa avaliação (>= 4.0)
  bool get hasGoodRating {
    return averageRating != null && averageRating! >= 4.0;
  }

  /// Retorna uma versão melhor da URL da thumbnail
  String? get betterThumbnail {
    if (thumbnail == null) return null;
    // Tentar obter uma imagem de melhor qualidade
    return thumbnail!.replaceAll('zoom=1', 'zoom=2');
  }

  /// URL da capa do livro com fallback pelo volume `id`
  /// Usa a thumbnail melhorada quando disponível; caso contrário, tenta carregar
  /// a capa diretamente do Google Books usando o `id` do volume.
  String? get coverUrl {
    final thumb = betterThumbnail;
    if (thumb != null && thumb.isNotEmpty) return thumb;
    if (id.isNotEmpty) {
      // Imagem pública da capa pelo volume id
      return 'https://books.google.com/books/content?id=$id&printsec=frontcover&img=1&zoom=1';
    }
    return null;
  }
}