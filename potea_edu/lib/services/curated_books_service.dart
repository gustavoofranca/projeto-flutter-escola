import '../models/book_model.dart';

/// Serviço para livros educacionais curados/pré-selecionados
class CuratedBooksService {
  /// Lista de livros educacionais brasileiros comumente usados em escolas
  static final List<Map<String, dynamic>> _brazilianEducationalBooks = [
    {
      'query': 'Dom Casmurro Machado de Assis',
      'category': 'Literatura Brasileira',
      'grade': 'Ensino Médio',
    },
    {
      'query': 'O Cortiço Aluísio Azevedo',
      'category': 'Literatura Brasileira',
      'grade': 'Ensino Médio',
    },
    {
      'query': 'Capitães da Areia Jorge Amado',
      'category': 'Literatura Brasileira',
      'grade': 'Ensino Médio',
    },
    {
      'query': 'Quincas Borba Machado de Assis',
      'category': 'Literatura Brasileira',
      'grade': 'Ensino Médio',
    },
    {
      'query': 'Matemática Fundamental Iezzi',
      'category': 'Matemática',
      'grade': 'Ensino Médio',
    },
    {
      'query': 'Física Conceitual Paul Hewitt',
      'category': 'Física',
      'grade': 'Ensino Médio',
    },
    {
      'query': 'Biologia Campbell',
      'category': 'Biologia',
      'grade': 'Ensino Médio',
    },
    {
      'query': 'História do Brasil Boris Fausto',
      'category': 'História',
      'grade': 'Ensino Médio',
    },
    {
      'query': 'Geografia do Brasil Jurandyr Ross',
      'category': 'Geografia',
      'grade': 'Ensino Médio',
    },
    {
      'query': 'Química Geral Atkins',
      'category': 'Química',
      'grade': 'Ensino Médio',
    },
    {
      'query': 'O Pequeno Príncipe Antoine de Saint-Exupéry',
      'category': 'Literatura Infantil',
      'grade': 'Ensino Fundamental',
    },
    {
      'query': 'Sítio do Picapau Amarelo Monteiro Lobato',
      'category': 'Literatura Infantil',
      'grade': 'Ensino Fundamental',
    },
    {
      'query': 'As Crônicas de Nárnia C.S. Lewis',
      'category': 'Literatura Fantástica',
      'grade': 'Ensino Fundamental',
    },
    {
      'query': 'Harry Potter Pedra Filosofal J.K. Rowling',
      'category': 'Literatura Fantástica',
      'grade': 'Ensino Fundamental',
    },
    {
      'query': 'Diário de um Banana Jeff Kinney',
      'category': 'Literatura Juvenil',
      'grade': 'Ensino Fundamental',
    },
  ];

  /// Lista de livros acadêmicos por disciplina
  static final Map<String, List<String>> _academicBooksBySubject = {
    'Matemática': [
      'Cálculo James Stewart',
      'Álgebra Linear Boldrini',
      'Matemática Discreta Kenneth Rosen',
      'Estatística Murray Spiegel',
    ],
    'Física': [
      'Física Halliday Resnick',
      'Mecânica Clássica Goldstein',
      'Eletromagnetismo Griffiths',
      'Física Moderna Tipler',
    ],
    'Química': [
      'Química Orgânica Clayden',
      'Físico-Química Atkins',
      'Química Analítica Skoog',
      'Bioquímica Lehninger',
    ],
    'Biologia': [
      'Biologia Molecular Alberts',
      'Genética Griffiths',
      'Ecologia Begon',
      'Anatomia Humana Sobotta',
    ],
    'História': [
      'História Moderna Perry Anderson',
      'História do Brasil Caio Prado Jr',
      'História Contemporânea Eric Hobsbawm',
      'Metodologia da História Marc Bloch',
    ],
    'Literatura': [
      'Teoria Literária Terry Eagleton',
      'História da Literatura Brasileira Antonio Candido',
      'Estilística Mattoso Camara',
      'Retórica Aristóteles',
    ],
    'Geografia': [
      'Geografia Física Arthur Strahler',
      'Geografia Humana Paul Knox',
      'Cartografia Robinson',
      'Climatologia Arthur Strahler',
    ],
    'Filosofia': [
      'História da Filosofia Giovanni Reale',
      'Ética Aristóteles',
      'Crítica da Razão Pura Kant',
      'Ser e Tempo Heidegger',
    ],
  };

  /// Retorna livros curados para a página inicial
  List<Map<String, dynamic>> getCuratedBooks() {
    return List.from(_brazilianEducationalBooks);
  }

  /// Retorna livros por disciplina
  List<String> getBooksBySubject(String subject) {
    return _academicBooksBySubject[subject] ?? [];
  }

  /// Retorna todas as disciplinas disponíveis
  List<String> getAvailableSubjects() {
    return _academicBooksBySubject.keys.toList();
  }

  /// Retorna livros por nível escolar
  List<Map<String, dynamic>> getBooksByGrade(String grade) {
    return _brazilianEducationalBooks
        .where((book) => book['grade'] == grade)
        .toList();
  }

  /// Retorna categorias de livros educacionais
  List<String> getEducationalCategories() {
    final categories = _brazilianEducationalBooks
        .map((book) => book['category'] as String)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  /// Retorna livros recomendados para leitura obrigatória
  List<Map<String, dynamic>> getMandatoryReadingBooks() {
    return _brazilianEducationalBooks
        .where((book) => book['category'] == 'Literatura Brasileira')
        .toList();
  }

  /// Retorna livros por faixa etária/série
  Map<String, List<Map<String, dynamic>>> getBooksByGradeLevel() {
    final Map<String, List<Map<String, dynamic>>> booksByGrade = {};
    
    for (final book in _brazilianEducationalBooks) {
      final grade = book['grade'] as String;
      booksByGrade[grade] ??= [];
      booksByGrade[grade]!.add(book);
    }
    
    return booksByGrade;
  }

  /// Busca livros curados por termo
  List<Map<String, dynamic>> searchCuratedBooks(String searchTerm) {
    final term = searchTerm.toLowerCase();
    return _brazilianEducationalBooks.where((book) {
      final query = book['query'] as String;
      final category = book['category'] as String;
      return query.toLowerCase().contains(term) || 
             category.toLowerCase().contains(term);
    }).toList();
  }
}