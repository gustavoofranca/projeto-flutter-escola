import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_dimensions.dart';
import '../../providers/book_download_provider.dart';
import '../../services/book_download_service.dart';
import '../../components/atoms/custom_typography.dart';

/// Tela de leitura de livros com funcionalidades básicas de leitor
class BookReaderScreen extends StatefulWidget {
  final BookModel book;

  const BookReaderScreen({super.key, required this.book});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 0;
  double _fontSize = 16.0;
  double _brightness = 1.0;
  bool _isDarkMode = true;
  bool _showControls = true;

  // Conteúdo simulado do livro (na prática, viria da API ou arquivo)
  List<String> _bookContent = [];

  @override
  void initState() {
    super.initState();
    _loadBookContent();
    _hideControlsAfterDelay();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadBookContent() {
    // Simula carregamento do conteúdo do livro
    // Na implementação real, isso viria da Google Books API ou arquivo local
    _bookContent = _generateSampleContent();
  }

  List<String> _generateSampleContent() {
    // Conteúdo de exemplo baseado no livro
    if (widget.book.title.toLowerCase().contains('dom casmurro')) {
      return _getDomCasmurroContent();
    } else if (widget.book.title.toLowerCase().contains('pequeno príncipe')) {
      return _getPequenoPrincipeContent();
    } else {
      return _getGenericContent();
    }
  }

  List<String> _getDomCasmurroContent() {
    return [
      '''Capítulo 1 - Do título

Uma noite destas, vindo da cidade para o Engenho Novo, encontrei num trem da Central um rapaz aqui do bairro, que eu conheço de vista e de chapéu. Cumprimentou-me, sentou-se ao pé de mim, falou da lua e dos ministros, e acabou recitando-me versos. A viagem era curta, e os versos pode ser que não fossem inteiramente maus. Faltava-lhe, porém, o método de arte, o polimento, a correção; e depois, fazia-me vir uma história velha, aquela dos versos com que os rapazes se consolam dos seus desgostos. Conheço essa história. Aí pelos vinte anos, quando eu não sabia bem onde estava a porta da rua nem para onde levava, também compus versos de moço.''',

      '''Capítulo 2 - Do livro

Agora que expliquei o título, passo a escrever o livro. Antes disso, porém, digamos os motivos que me põem a pena na mão.

Vivo só, com um criado. A casa em que moro é própria; fi-la construir de propósito, levado de um desejo tão particular que me vexa imprimi-lo, mas vá lá. Um dia, há bastantes anos, lembrou-me reproduzir no Engenho Novo a casa em que me criei na antiga Rua de Mata-cavalos, dando-lhe o mesmo aspecto e economia daquela outra, que desapareceu.''',

      '''Capítulo 3 - A denúncia

A minha mãe era amiga íntima da mãe de Capitu. Foram criadas juntas, brincaram juntas, até se casarem. Casaram ambas cedo; minha mãe saiu da casa materna para a de meu pai, Capitu saiu da sua para uma casa ao pé. Pequena, baixa, com uma janela e duas portas. Quem passou pela antiga Rua de Mata-cavalos, indo para o Andaraí, havia de ver a casa. Não era feia, tinha uma aparência acolhedora; mas comparada com a nossa, fazia lembrar uma dessas pessoas que, sem serem propriamente feias, são mais simpáticas que bonitas.''',
    ];
  }

  List<String> _getPequenoPrincipeContent() {
    return [
      '''Capítulo 1

Quando eu tinha seis anos vi uma vez uma figura magnífica num livro sobre a Floresta Virgem que se chamava "Histórias Vividas". Representava uma jiboia que engolia uma fera. Eis a cópia do desenho.

Dizia o livro: "As jiboias engolem a presa inteira, sem mastigar. Em seguida não conseguem mover-se e dormem os seis meses da digestão."

Refleti muito então sobre as aventuras da selva e consegui, por minha vez, traçar com lápis de cor o meu primeiro desenho. O meu desenho número 1 era assim...''',

      '''Capítulo 2

Vivi assim sozinho, sem ninguém com quem pudesse falar verdadeiramente, até uma pane no deserto do Saara, há seis anos. Qualquer coisa se partira no meu motor. E como não tinha comigo nem mecânico nem passageiros, preparei-me para tentar, sozinho, um conserto difícil. Era para mim questão de vida ou morte. Tinha água apenas para oito dias.

Na primeira noite dormi sobre a areia a mil milhas de qualquer terra habitada. Estava mais isolado que um náufrago numa jangada em pleno oceano.''',

      '''Capítulo 3

Foi então que apareceu o pequeno príncipe.

Quando um mistério é muito impressionante, ninguém ousa desobedecer. Por mais absurdo que me parecesse, a mil milhas de qualquer lugar habitado e em perigo de morte, tirei do bolso uma folha de papel e uma caneta. Lembrei-me então de que estudara sobretudo geografia, história, cálculo e gramática, e disse ao rapazinho (com um pouco de mau humor) que não sabia desenhar.''',
    ];
  }

  List<String> _getGenericContent() {
    return [
      '''Prefácio

Este é um livro educacional que apresenta conceitos fundamentais de forma clara e acessível. Os capítulos estão organizados de maneira progressiva, permitindo um aprendizado gradual e consistente.

O conteúdo foi cuidadosamente elaborado para atender às necessidades dos estudantes modernos, combinando teoria sólida com exemplos práticos e exercícios interativos.''',

      '''Capítulo 1 - Introdução

Neste primeiro capítulo, estabelecemos as bases conceituais que serão desenvolvidas ao longo do livro. É importante compreender que cada conceito se constrói sobre os anteriores, formando uma estrutura coesa de conhecimento.

Os exemplos apresentados foram selecionados para ilustrar situações do cotidiano, facilitando a compreensão e aplicação prática dos conceitos estudados.''',

      '''Capítulo 2 - Desenvolvimento

Avançando em nossa jornada de aprendizado, este capítulo aprofunda os conceitos introduzidos anteriormente. Aqui, exploramos as nuances e aplicações mais complexas, sempre mantendo o foco na clareza e na aplicabilidade prática.

É fundamental que o estudante dedique tempo suficiente para absorver completamente o conteúdo antes de prosseguir para os próximos capítulos.''',
    ];
  }

  void _hideControlsAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      _hideControlsAfterDelay();
    }
  }

  void _nextPage() {
    if (_currentPage < _bookContent.length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _adjustFontSize(double delta) {
    setState(() {
      _fontSize = (_fontSize + delta).clamp(12.0, 24.0);
    });
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  Future<void> _downloadBook(BuildContext context) async {
    // Funcionalidade de download removida
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade de download removida. Use o botão "Acessar Livro" para ler o conteúdo.'),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color get _backgroundColor =>
      _isDarkMode ? AppColors.background : const Color(0xFFF5F5F5);
  Color get _textColor =>
      _isDarkMode ? AppColors.textPrimary : const Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Main content
            SafeArea(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _bookContent.length,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(AppDimensions.xl),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40), // Space for top controls
                          // Chapter content
                          Text(
                            _bookContent[index],
                            style: TextStyle(
                              fontSize: _fontSize,
                              height: 1.6,
                              color: _textColor,
                              fontFamily: 'Georgia',
                            ),
                            textAlign: TextAlign.justify,
                          ),

                          const SizedBox(
                            height: 80,
                          ), // Space for bottom controls
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Controls overlay
            if (_showControls) ...[
              // Top controls
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.lg,
                    vertical: AppDimensions.md,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _backgroundColor,
                        _backgroundColor.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: _textColor),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              CustomTypography.h6(
                                text: widget.book.title,
                                color: _textColor,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              CustomTypography.caption(
                                text:
                                    'Página ${_currentPage + 1} de ${_bookContent.length}',
                                color: _textColor.withValues(alpha: 0.7),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.settings, color: _textColor),
                          onPressed: _showSettingsDialog,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom controls
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.lg),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        _backgroundColor,
                        _backgroundColor.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: _currentPage > 0
                                ? _textColor
                                : _textColor.withValues(alpha: 0.3),
                          ),
                          onPressed: _currentPage > 0 ? _previousPage : null,
                        ),

                        // Progress indicator
                        Expanded(
                          child: Container(
                            height: 4,
                            margin: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.lg,
                            ),
                            decoration: BoxDecoration(
                              color: _textColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor:
                                  (_currentPage + 1) / _bookContent.length,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),

                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: _currentPage < _bookContent.length - 1
                                ? _textColor
                                : _textColor.withValues(alpha: 0.3),
                          ),
                          onPressed: _currentPage < _bookContent.length - 1
                              ? _nextPage
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const CustomTypography.h6(
          text: 'Configurações de Leitura',
          color: AppColors.textPrimary,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Font size
            Row(
              children: [
                const CustomTypography.bodyMedium(
                  text: 'Tamanho da fonte:',
                  color: AppColors.textPrimary,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.remove,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () => _adjustFontSize(-2),
                ),
                CustomTypography.bodyMedium(
                  text: _fontSize.toInt().toString(),
                  color: AppColors.textPrimary,
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: AppColors.textSecondary),
                  onPressed: () => _adjustFontSize(2),
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.md),

            // Dark mode toggle
            Row(
              children: [
                const CustomTypography.bodyMedium(
                  text: 'Modo escuro:',
                  color: AppColors.textPrimary,
                ),
                const Spacer(),
                Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    _toggleDarkMode();
                    Navigator.of(context).pop();
                  },
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const CustomTypography.bodyMedium(
              text: 'Fechar',
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
