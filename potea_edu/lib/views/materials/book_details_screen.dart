import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_dimensions.dart';
import '../../models/book_model.dart';
import '../../providers/book_download_provider.dart';
import '../../components/atoms/custom_typography.dart';
import '../../components/atoms/custom_button.dart';

/// Tela de detalhes do livro com informações completas
class BookDetailsScreen extends StatelessWidget {
  final BookModel book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const CustomTypography.h6(
          text: 'Detalhes do Livro',
          color: AppColors.textPrimary,
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.textPrimary),
            onPressed: () => _shareBook(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with book cover and basic info
            _buildHeader(),

            // Book details
            Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  if (book.description != null) ...[
                    _buildSection(
                      'Descrição',
                      CustomTypography.bodyMedium(
                        text: book.description!,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xl),
                  ],

                  // Book info
                  _buildBookInfo(context),

                  const SizedBox(height: AppDimensions.xl),

                  // Action buttons
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.background.withValues(alpha: 0.8),
              AppColors.background.withValues(alpha: 0.6),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              child: Container(
                width: 120,
                height: 180,
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

            const SizedBox(width: AppDimensions.lg),

            // Book Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTypography.h4(
                    text: book.title,
                    color: AppColors.textPrimary,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppDimensions.sm),

                  CustomTypography.h6(
                    text: book.authorsString,
                    color: AppColors.textSecondary,
                  ),

                  if (book.publisher != null) ...[
                    const SizedBox(height: AppDimensions.xs),
                    CustomTypography.bodyMedium(
                      text: book.publisher!,
                      color: AppColors.textSecondary,
                    ),
                  ],

                  if (book.publishedDate != null) ...[
                    const SizedBox(height: AppDimensions.xs),
                    CustomTypography.bodyMedium(
                      text: 'Publicado em ${book.publishYear}',
                      color: AppColors.textSecondary,
                    ),
                  ],

                  if (book.averageRating != null) ...[
                    const SizedBox(height: AppDimensions.md),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            size: 20,
                            color: index < book.averageRating!.round()
                                ? AppColors.warning
                                : AppColors.textSecondary.withValues(
                                    alpha: 0.3,
                                  ),
                          );
                        }),
                        const SizedBox(width: AppDimensions.sm),
                        CustomTypography.bodyMedium(
                          text:
                              '${book.averageRating!.toStringAsFixed(1)} (${book.ratingsCount ?? 0})',
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],

                  if (book.categories.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.md),
                    Wrap(
                      spacing: AppDimensions.xs,
                      runSpacing: AppDimensions.xs,
                      children: book.categories.take(3).map((category) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.sm,
                            vertical: AppDimensions.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusXs,
                            ),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: CustomTypography.caption(
                            text: category,
                            color: AppColors.primary,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTypography.h6(text: title, color: AppColors.textPrimary),
        const SizedBox(height: AppDimensions.md),
        content,
      ],
    );
  }

  Widget _buildBookInfo(BuildContext context) {
    final downloadProvider = Provider.of<BookDownloadProvider>(
      context,
      listen: false,
    );
    final estimatedSize = downloadProvider.getEstimatedFileSize(book);

    final infoItems = <Map<String, String>>[
      if (book.pageCount != null)
        {'label': 'Páginas', 'value': '${book.pageCount} páginas'},
      if (book.language != null)
        {'label': 'Idioma', 'value': _getLanguageName(book.language!)},
      if (book.isbn13 != null) {'label': 'ISBN-13', 'value': book.isbn13!},
      if (book.isbn10 != null) {'label': 'ISBN-10', 'value': book.isbn10!},
      {'label': 'Tamanho estimado', 'value': estimatedSize},
    ];

    if (infoItems.isEmpty) return const SizedBox();

    return _buildSection(
      'Informações do Livro',
      Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          children: infoItems.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTypography.bodyMedium(
                    text: item['label']!,
                    color: AppColors.textSecondary,
                  ),
                  Flexible(
                    child: CustomTypography.bodyMedium(
                      text: item['value']!,
                      color: AppColors.textPrimary,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Download button
        _buildDownloadButton(context),

        const SizedBox(height: AppDimensions.md),

        if (book.previewLink != null)
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Visualizar Prévia',
              icon: Icons.preview,
              onPressed: () => _openPreview(context),
            ),
          ),

        const SizedBox(height: AppDimensions.md),

        Row(
          children: [
            if (book.infoLink != null)
              Expanded(
                child: CustomButton(
                  text: 'Mais Info',
                  variant: CustomButtonVariant.outlined,
                  icon: Icons.info_outline,
                  onPressed: () => _openInfoLink(context),
                ),
              ),

            if (book.infoLink != null && book.isbn13 != null)
              const SizedBox(width: AppDimensions.md),

            if (book.isbn13 != null)
              Expanded(
                child: CustomButton(
                  text: 'Copiar ISBN',
                  variant: CustomButtonVariant.secondary,
                  icon: Icons.copy,
                  onPressed: () => _copyIsbn(context),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return Consumer<BookDownloadProvider>(
      builder: (context, downloadProvider, child) {
        final isDownloaded = downloadProvider.isBookDownloaded(book.id);
        final downloadProgress = downloadProvider.getDownloadProgress(book.id);

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: downloadProgress != null
                ? null
                : () => _downloadBook(context, downloadProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDownloaded
                  ? AppColors.success
                  : AppColors.secondary,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.lg,
                vertical: AppDimensions.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              elevation: 0,
            ),
            child: downloadProgress != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          value: downloadProgress,
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      CustomTypography.bodyMedium(
                        text:
                            'Baixando... ${(downloadProgress * 100).toInt()}%',
                        color: Colors.black,
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isDownloaded ? Icons.download_done : Icons.download,
                        color: Colors.black,
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      CustomTypography.bodyMedium(
                        text: isDownloaded ? 'PDF Baixado' : 'Baixar PDF',
                        color: Colors.black,
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
        child: Icon(Icons.book, color: AppColors.textSecondary, size: 60),
      ),
    );
  }

  String _getLanguageName(String code) {
    final languages = {
      'pt': 'Português',
      'en': 'Inglês',
      'es': 'Espanhol',
      'fr': 'Francês',
      'de': 'Alemão',
      'it': 'Italiano',
    };
    return languages[code] ?? code.toUpperCase();
  }

  void _shareBook(BuildContext context) {
    final text =
        'Confira este livro: "${book.title}" por ${book.authorsString}';
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Informações do livro copiadas!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _downloadBook(
    BuildContext context,
    BookDownloadProvider downloadProvider,
  ) async {
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

  void _openPreview(BuildContext context) async {
    if (book.previewLink != null) {
      final Uri url = Uri.parse(book.previewLink!);
      if (await launchUrl(url)) {
        // URL aberta com sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prévia do livro aberta!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        // Falha ao abrir URL
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível abrir a prévia do livro'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Livro não possui prévia disponível'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _openInfoLink(BuildContext context) async {
    if (book.infoLink != null) {
      final Uri url = Uri.parse(book.infoLink!);
      if (await launchUrl(url)) {
        // URL aberta com sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Informações do livro abertas!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        // Falha ao abrir URL
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível abrir as informações do livro'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Livro não possui link de informações'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _copyIsbn(BuildContext context) {
    final isbn = book.isbn13 ?? book.isbn10;
    if (isbn != null) {
      Clipboard.setData(ClipboardData(text: isbn));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ISBN copiado para a área de transferência!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
