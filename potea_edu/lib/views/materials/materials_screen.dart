import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:potea_edu/constants/app_colors.dart';
import 'package:potea_edu/constants/app_dimensions.dart';
import '../../providers/curated_books_provider.dart';
import '../../providers/book_download_provider.dart';
import '../../models/book_model.dart';
import '../../services/google_books_service.dart';
import '../../services/curated_books_service.dart';
import '../../components/atoms/custom_button.dart';
import '../../components/atoms/custom_typography.dart';
import '../../components/molecules/info_card.dart';
import '../../components/molecules/section_title.dart';
import 'book_details_screen.dart';
import 'book_reader_screen.dart';

/// Tela de materiais educacionais com integração ao Google Books
class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  final GoogleBooksService _booksService = GoogleBooksService();
  final CuratedBooksService _curatedService = CuratedBooksService();
  final TextEditingController _searchController = TextEditingController();

  List<BookModel> _books = [];
  List<BookModel> _featuredBooks = [];
  List<BookModel> _curatedBooks = [];
  bool _isLoading = false;
  bool _isLoadingFeatured = true;
  bool _isLoadingCurated = true;
  String _currentQuery = '';

  final List<String> _categories = [
    'Matemática',
    'Ciências',
    'História',
    'Literatura',
    'Programação',
    'Ficção',
  ];

  @override
  void initState() {
    super.initState();
    _loadFeaturedBooks();
    _loadCuratedBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFeaturedBooks() async {
    try {
      final books = await _booksService.getPopularBooks('education');
      if (mounted) {
        setState(() {
          _featuredBooks = books.take(10).toList();
          _isLoadingFeatured = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingFeatured = false;
        });
        _showErrorSnackBar('Erro ao carregar livros em destaque');
      }
    }
  }

  Future<void> _loadCuratedBooks() async {
    try {
      final curatedBookQueries = _curatedService.getCuratedBooks();
      final List<BookModel> loadedBooks = [];

      // Carregar alguns livros curados (limitando para não sobrecarregar)
      for (int i = 0; i < curatedBookQueries.take(8).length; i++) {
        try {
          final query = curatedBookQueries[i]['query'] as String;
          final books = await _booksService.searchBooks(query);
          if (books.isNotEmpty) {
            loadedBooks.add(books.first);
          }
        } catch (e) {
          // Continua mesmo se um livro falhar
          continue;
        }
      }

      if (mounted) {
        setState(() {
          _curatedBooks = loadedBooks;
          _isLoadingCurated = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingCurated = false;
        });
      }
    }
  }

  Future<void> _searchBooks(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _currentQuery = query;
    });

    try {
      final books = await _booksService.searchEducationalBooks(query);
      if (mounted) {
        setState(() {
          _books = books;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Erro ao buscar livros');
      }
    }
  }

  Future<void> _searchByCategory(String category) async {
    setState(() {
      _isLoading = true;
      _currentQuery = category;
    });

    try {
      final books = await _booksService.searchBooksBySubject(
        category.toLowerCase(),
      );
      if (mounted) {
        setState(() {
          _books = books;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Erro ao buscar livros da categoria');
      }
    }
  }

  void _filterByGrade(String grade) async {
    setState(() {
      _isLoadingCurated = true;
      _currentQuery = grade;
    });

    try {
      final curatedBookQueries = _curatedService.getBooksByGrade(grade);
      final List<BookModel> loadedBooks = [];

      for (int i = 0; i < curatedBookQueries.take(6).length; i++) {
        try {
          final query = curatedBookQueries[i]['query'] as String;
          final books = await _booksService.searchBooks(query);
          if (books.isNotEmpty) {
            loadedBooks.add(books.first);
          }
        } catch (e) {
          continue;
        }
      }

      if (mounted) {
        setState(() {
          _curatedBooks = loadedBooks;
          _isLoadingCurated = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingCurated = false;
        });
        _showErrorSnackBar('Erro ao carregar livros por série');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openBookDetails(BookModel book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookDetailsScreen(book: book)),
    );
  }

  void _openBookReader(BookModel book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookReaderScreen(book: book)),
    );
  }

  Future<void> _downloadBook(BuildContext context, BookModel book) async {
    final downloadProvider = Provider.of<BookDownloadProvider>(
      context,
      listen: false,
    );

    // Se já está baixado, mostra mensagem
    if (downloadProvider.isBookDownloaded(book.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Livro já baixado!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Inicia o download
    final result = await downloadProvider.downloadBook(book);

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Livro baixado com sucesso!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao baixar o livro'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const CustomTypography.h6(
          text: 'Materiais Educacionais',
          color: AppColors.textPrimary,
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            _buildSearchBar(),

            const SizedBox(height: AppDimensions.xl),

            // Categories
            _buildCategories(),

            const SizedBox(height: AppDimensions.xl),

            // Curated Educational Books (when no search)
            if (_currentQuery.isEmpty) ...[
              const SectionTitle(
                title: 'Livros Educacionais Recomendados',
                subtitle: 'Livros comumente usados em escolas brasileiras',
              ),
              const SizedBox(height: AppDimensions.lg),
              _buildCuratedBooks(),

              const SizedBox(height: AppDimensions.xl),

              const SectionTitle(
                title: 'Livros em Destaque',
                subtitle: 'Materiais educacionais populares',
              ),
              const SizedBox(height: AppDimensions.lg),
              _buildFeaturedBooks(),
            ],

            // Search Results
            if (_currentQuery.isNotEmpty) ...[
              SectionTitle(
                title: 'Resultados para "$_currentQuery"',
                subtitle: '${_books.length} livros encontrados',
              ),
              const SizedBox(height: AppDimensions.lg),
              _buildSearchResults(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Buscar livros educacionais...',
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _books = [];
                      _currentQuery = '';
                    });
                    _loadCuratedBooks(); // Reload curated books
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
            vertical: AppDimensions.md,
          ),
        ),
        onSubmitted: _searchBooks,
        onChanged: (value) {
          setState(() {}); // Para atualizar o botão clear
        },
      ),
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomTypography.h6(
          text: 'Categorias',
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: AppDimensions.md),
        Wrap(
          spacing: AppDimensions.sm,
          runSpacing: AppDimensions.sm,
          children: _categories.map((category) {
            return GestureDetector(
              onTap: () => _searchByCategory(category),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.md,
                  vertical: AppDimensions.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: CustomTypography.bodyMedium(
                  text: category,
                  color: AppColors.primary,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCuratedBooks() {
    if (_isLoadingCurated) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_curatedBooks.isEmpty) {
      return _buildEmptyState('Nenhum livro curado disponível');
    }

    return Column(
      children: [
        // Grade levels tabs
        _buildGradeLevelTabs(),

        const SizedBox(height: AppDimensions.lg),

        // Curated books grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            crossAxisSpacing: AppDimensions.md,
            mainAxisSpacing: AppDimensions.md,
          ),
          itemCount: _curatedBooks.length,
          itemBuilder: (context, index) {
            return _buildCuratedBookCard(_curatedBooks[index]);
          },
        ),
      ],
    );
  }

  Widget _buildGradeLevelTabs() {
    final gradeLevels = ['Ensino Fundamental', 'Ensino Médio'];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: gradeLevels.length,
        itemBuilder: (context, index) {
          final grade = gradeLevels[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index == gradeLevels.length - 1 ? 0 : AppDimensions.sm,
            ),
            child: GestureDetector(
              onTap: () => _filterByGrade(grade),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.lg,
                  vertical: AppDimensions.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.3),
                  ),
                ),
                child: Center(
                  child: CustomTypography.bodyMedium(
                    text: grade,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCuratedBookCard(BookModel book) {
    return Consumer<BookDownloadProvider>(
      builder: (context, downloadProvider, child) {
        final isDownloaded = downloadProvider.isBookDownloaded(book.id);
        final downloadProgress = downloadProvider.getDownloadProgress(book.id);

        return GestureDetector(
          onTap: () => _openBookDetails(book),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Cover
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppDimensions.radiusMd),
                    ),
                    child: Container(
                      width: double.infinity,
                      color: AppColors.surfaceLight,
                      child: book.thumbnail != null
                          ? Image.network(
                              book.betterThumbnail!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildBookPlaceholder(),
                            )
                          : _buildBookPlaceholder(),
                    ),
                  ),
                ),

                // Book Info
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTypography.bodyMedium(
                          text: book.title,
                          color: AppColors.textPrimary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppDimensions.xs),
                        CustomTypography.bodySmall(
                          text: book.authorsString,
                          color: AppColors.textSecondary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _openBookReader(book),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppDimensions.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusXs,
                                    ),
                                    border: Border.all(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: const Center(
                                    child: CustomTypography.caption(
                                      text: 'Ler',
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppDimensions.xs),
                            Expanded(
                              child: GestureDetector(
                                onTap: downloadProgress != null
                                    ? null
                                    : () => _downloadBook(context, book),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppDimensions.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDownloaded
                                        ? AppColors.success.withValues(
                                            alpha: 0.1,
                                          )
                                        : AppColors.secondary.withValues(
                                            alpha: 0.1,
                                          ),
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusXs,
                                    ),
                                    border: Border.all(
                                      color: isDownloaded
                                          ? AppColors.success.withValues(
                                              alpha: 0.3,
                                            )
                                          : AppColors.secondary.withValues(
                                              alpha: 0.3,
                                            ),
                                    ),
                                  ),
                                  child: Center(
                                    child: downloadProgress != null
                                        ? SizedBox(
                                            height: 16,
                                            width: 16,
                                            child: CircularProgressIndicator(
                                              value: downloadProgress,
                                              strokeWidth: 2,
                                              color: AppColors.secondary,
                                            ),
                                          )
                                        : CustomTypography.caption(
                                            text: isDownloaded ? '✓' : '⬇',
                                            color: isDownloaded
                                                ? AppColors.success
                                                : AppColors.secondary,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturedBooks() {
    if (_isLoadingFeatured) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_featuredBooks.isEmpty) {
      return _buildEmptyState('Nenhum livro em destaque disponível');
    }

    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _featuredBooks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index == _featuredBooks.length - 1 ? 0 : AppDimensions.md,
            ),
            child: _buildBookCard(_featuredBooks[index], isHorizontal: true),
          );
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.xl),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_books.isEmpty) {
      return _buildEmptyState('Nenhum livro encontrado');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _books.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.md),
          child: _buildBookCard(_books[index]),
        );
      },
    );
  }

  Widget _buildBookCard(BookModel book, {bool isHorizontal = false}) {
    if (isHorizontal) {
      return Consumer<BookDownloadProvider>(
        builder: (context, downloadProvider, child) {
          final isDownloaded = downloadProvider.isBookDownloaded(book.id);
          final downloadProgress = downloadProvider.getDownloadProgress(
            book.id,
          );

          return GestureDetector(
            onTap: () => _openBookDetails(book),
            child: Container(
              width: 160,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Cover
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppDimensions.radiusMd),
                    ),
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      color: AppColors.surfaceLight,
                      child: book.thumbnail != null
                          ? Image.network(
                              book.betterThumbnail!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildBookPlaceholder(),
                            )
                          : _buildBookPlaceholder(),
                    ),
                  ),

                  // Book Info
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTypography.bodyMedium(
                            text: book.title,
                            color: AppColors.textPrimary,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppDimensions.xs),
                          CustomTypography.bodySmall(
                            text: book.authorsString,
                            color: AppColors.textSecondary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (book.averageRating != null) ...[
                            const SizedBox(height: AppDimensions.xs),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: 4),
                                CustomTypography.bodySmall(
                                  text: book.averageRating!.toStringAsFixed(1),
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ],
                          const Spacer(),
                          // Download button
                          GestureDetector(
                            onTap: downloadProgress != null
                                ? null
                                : () => _downloadBook(context, book),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppDimensions.xs,
                              ),
                              decoration: BoxDecoration(
                                color: isDownloaded
                                    ? AppColors.success.withValues(alpha: 0.1)
                                    : AppColors.secondary.withValues(
                                        alpha: 0.1,
                                      ),
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusXs,
                                ),
                                border: Border.all(
                                  color: isDownloaded
                                      ? AppColors.success.withValues(alpha: 0.3)
                                      : AppColors.secondary.withValues(
                                          alpha: 0.3,
                                        ),
                                ),
                              ),
                              child: Center(
                                child: downloadProgress != null
                                    ? SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          value: downloadProgress,
                                          strokeWidth: 2,
                                          color: AppColors.secondary,
                                        ),
                                      )
                                    : CustomTypography.caption(
                                        text: isDownloaded
                                            ? '✓ Baixado'
                                            : '⬇ Baixar',
                                        color: isDownloaded
                                            ? AppColors.success
                                            : AppColors.secondary,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    // Vertical card for search results
    return Consumer<BookDownloadProvider>(
      builder: (context, downloadProvider, child) {
        final isDownloaded = downloadProvider.isBookDownloaded(book.id);
        final downloadProgress = downloadProvider.getDownloadProgress(book.id);

        return GestureDetector(
          onTap: () => _openBookDetails(book),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Cover
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  child: Container(
                    width: 80,
                    height: 120,
                    color: AppColors.surfaceLight,
                    child: book.thumbnail != null
                        ? Image.network(
                            book.betterThumbnail!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildBookPlaceholder(),
                          )
                        : _buildBookPlaceholder(),
                  ),
                ),

                const SizedBox(width: AppDimensions.md),

                // Book Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTypography.h6(
                        text: book.title,
                        color: AppColors.textPrimary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      CustomTypography.bodyMedium(
                        text: book.authorsString,
                        color: AppColors.textSecondary,
                      ),
                      if (book.publishedDate != null) ...[
                        const SizedBox(height: AppDimensions.xs),
                        CustomTypography.bodySmall(
                          text: 'Publicado em ${book.publishYear}',
                          color: AppColors.textSecondary,
                        ),
                      ],
                      if (book.categoriesString.isNotEmpty) ...[
                        const SizedBox(height: AppDimensions.xs),
                        CustomTypography.bodySmall(
                          text: book.categoriesString,
                          color: AppColors.primary,
                        ),
                      ],
                      if (book.averageRating != null) ...[
                        const SizedBox(height: AppDimensions.sm),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 4),
                            CustomTypography.bodySmall(
                              text:
                                  '${book.averageRating!.toStringAsFixed(1)} (${book.ratingsCount ?? 0} avaliações)',
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ],
                      if (book.description != null) ...[
                        const SizedBox(height: AppDimensions.sm),
                        CustomTypography.bodySmall(
                          text: book.description!,
                          color: AppColors.textSecondary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: AppDimensions.sm),
                      // Download button
                      GestureDetector(
                        onTap: downloadProgress != null
                            ? null
                            : () => _downloadBook(context, book),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.sm,
                            vertical: AppDimensions.xs,
                          ),
                          decoration: BoxDecoration(
                            color: isDownloaded
                                ? AppColors.success.withValues(alpha: 0.1)
                                : AppColors.secondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusXs,
                            ),
                            border: Border.all(
                              color: isDownloaded
                                  ? AppColors.success.withValues(alpha: 0.3)
                                  : AppColors.secondary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                downloadProgress != null
                                    ? Icons.downloading
                                    : isDownloaded
                                    ? Icons.download_done
                                    : Icons.download,
                                size: 16,
                                color: isDownloaded
                                    ? AppColors.success
                                    : AppColors.secondary,
                              ),
                              const SizedBox(width: AppDimensions.xs),
                              downloadProgress != null
                                  ? CustomTypography.caption(
                                      text:
                                          '${(downloadProgress * 100).toInt()}%',
                                      color: AppColors.secondary,
                                    )
                                  : CustomTypography.caption(
                                      text: isDownloaded
                                          ? 'Baixado'
                                          : 'Baixar PDF',
                                      color: isDownloaded
                                          ? AppColors.success
                                          : AppColors.secondary,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookPlaceholder() {
    return Container(
      color: AppColors.surfaceLight,
      child: const Center(
        child: Icon(Icons.book, color: AppColors.textSecondary, size: 40),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          children: [
            Icon(
              Icons.book_outlined,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppDimensions.lg),
            CustomTypography.h6(
              text: message,
              color: AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
