import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_dimensions.dart';
import '../../components/atoms/custom_typography.dart';
import '../../components/molecules/info_card.dart';
import '../../providers/auth_provider.dart';

/// Tela de demonstração do consumo de API com FutureBuilder
class ApiDemoScreen extends StatefulWidget {
  const ApiDemoScreen({super.key});

  @override
  State<ApiDemoScreen> createState() => _ApiDemoScreenState();
}

class _ApiDemoScreenState extends State<ApiDemoScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Post>> _postsFuture;
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _refreshData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshData() {
    setState(() {
      _postsFuture = ApiService.getPosts();
      _usersFuture = ApiService.getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Verifica se o usuário tem permissão para acessar a demo
    if (authProvider.isStudent) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: AppDimensions.lg),
                const Text(
                  'Acesso Restrito',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
                const Text(
                  'Esta funcionalidade de demonstração está disponível apenas para professores e administradores.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.xl,
                      vertical: AppDimensions.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  child: const Text('Voltar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const CustomTypography.h5(
          text: 'Demonstração de API',
          color: AppColors.textPrimary,
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          Semantics(
            button: true,
            label: 'Atualizar dados',
            hint: 'Toque para recarregar os dados da API',
            child: IconButton(
              onPressed: _refreshData,
              icon: const Icon(
                Icons.refresh,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Posts', icon: Icon(Icons.article)),
            Tab(text: 'Usuários', icon: Icon(Icons.people)),
            Tab(text: 'Criar Post', icon: Icon(Icons.add)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPostsTab(),
          _buildUsersTab(),
          _buildCreatePostTab(),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    return Semantics(
      label: 'Lista de posts',
      child: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState('Carregando posts...');
          }

          if (snapshot.hasError) {
            return _buildErrorState(
              'Erro ao carregar posts',
              snapshot.error.toString(),
              _refreshData,
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(
              'Nenhum post encontrado',
              'Tente novamente mais tarde',
              Icons.article_outlined,
            );
          }

          final posts = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.lg),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.md),
                child: InfoCard(
                  title: post.title,
                  description: post.body,
                  subtitle: 'Post #${post.id} • Usuário ${post.userId}',
                  icon: Icons.article,
                  iconColor: AppColors.primary,
                  onTap: () => _showPostDetails(post),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildUsersTab() {
    return Semantics(
      label: 'Lista de usuários',
      child: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState('Carregando usuários...');
          }

          if (snapshot.hasError) {
            return _buildErrorState(
              'Erro ao carregar usuários',
              snapshot.error.toString(),
              _refreshData,
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(
              'Nenhum usuário encontrado',
              'Tente novamente mais tarde',
              Icons.people_outlined,
            );
          }

          final users = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.lg),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.md),
                child: InfoCard(
                  title: user.name,
                  subtitle: '@${user.username}',
                  description: '${user.email}\n${user.company.name}',
                  icon: Icons.person,
                  iconColor: AppColors.secondary,
                  onTap: () => _showUserDetails(user),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCreatePostTab() {
    return const CreatePostForm();
  }

  Widget _buildLoadingState(String message) {
    return Semantics(
      label: message,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: AppDimensions.lg),
            CustomTypography.bodyMedium(
              text: message,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String title, String error, VoidCallback onRetry) {
    return Semantics(
      label: 'Erro: $title',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: AppDimensions.lg),
              CustomTypography.h6(
                text: title,
                color: AppColors.textPrimary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.md),
              CustomTypography.bodyMedium(
                text: error,
                color: AppColors.textSecondary,
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
              const SizedBox(height: AppDimensions.xl),
              CustomButton(
                text: 'Tentar Novamente',
                onPressed: onRetry,
                icon: Icons.refresh,
                variant: CustomButtonVariant.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String description, IconData icon) {
    return Semantics(
      label: 'Estado vazio: $title',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: AppDimensions.lg),
              CustomTypography.h6(
                text: title,
                color: AppColors.textPrimary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.md),
              CustomTypography.bodyMedium(
                text: description,
                color: AppColors.textSecondary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPostDetails(Post post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLg),
        ),
      ),
      builder: (context) => PostDetailsModal(post: post),
    );
  }

  void _showUserDetails(User user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLg),
        ),
      ),
      builder: (context) => UserDetailsModal(user: user),
    );
  }
}

/// Modal com detalhes do post
class PostDetailsModal extends StatefulWidget {
  final Post post;

  const PostDetailsModal({super.key, required this.post});

  @override
  State<PostDetailsModal> createState() => _PostDetailsModalState();
}

class _PostDetailsModalState extends State<PostDetailsModal> {
  late Future<List<Comment>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = ApiService.getPostComments(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.lg),

          // Post details
          CustomTypography.h5(
            text: widget.post.title,
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppDimensions.md),
          CustomTypography.bodyMedium(
            text: widget.post.body,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppDimensions.lg),

          // Comments
          const CustomTypography.h6(
            text: 'Comentários',
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppDimensions.md),

          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: CustomTypography.bodyMedium(
                      text: 'Erro ao carregar comentários',
                      color: AppColors.error,
                    ),
                  );
                }

                final comments = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.md),
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.md),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTypography.bodySmall(
                              text: comment.name,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: AppDimensions.xs),
                            CustomTypography.caption(
                              text: comment.email,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: AppDimensions.sm),
                            CustomTypography.bodyMedium(
                              text: comment.body,
                              color: AppColors.textPrimary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Modal com detalhes do usuário
class UserDetailsModal extends StatelessWidget {
  final User user;

  const UserDetailsModal({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.lg),

          // User details
          CustomTypography.h5(
            text: user.name,
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppDimensions.sm),
          CustomTypography.bodyMedium(
            text: '@${user.username}',
            color: AppColors.primary,
          ),
          const SizedBox(height: AppDimensions.lg),

          // Contact info
          _buildInfoRow(Icons.email, 'Email', user.email),
          _buildInfoRow(Icons.phone, 'Telefone', user.phone),
          _buildInfoRow(Icons.web, 'Website', user.website),
          
          const SizedBox(height: AppDimensions.lg),

          // Company info
          const CustomTypography.h6(
            text: 'Empresa',
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppDimensions.md),
          CustomTypography.bodyMedium(
            text: user.company.name,
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppDimensions.xs),
          CustomTypography.bodySmall(
            text: user.company.catchPhrase,
            color: AppColors.textSecondary,
          ),
          
          const SizedBox(height: AppDimensions.lg),

          // Address
          const CustomTypography.h6(
            text: 'Endereço',
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppDimensions.md),
          CustomTypography.bodyMedium(
            text: '${user.address.street}, ${user.address.suite}\n${user.address.city} - ${user.address.zipcode}',
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppDimensions.iconSizeMd,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: CustomTypography.bodyMedium(
              text: value,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Formulário para criar post
class CreatePostForm extends StatefulWidget {
  const CreatePostForm({super.key});

  @override
  State<CreatePostForm> createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<CreatePostForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _userIdController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: 'Criar Novo Post',
              subtitle: 'Preencha os campos abaixo para criar um post',
            ),
            
            const SizedBox(height: AppDimensions.lg),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Title field
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título do Post',
                        hintText: 'Digite o título...',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Título é obrigatório';
                        }
                        if (value.trim().length < 5) {
                          return 'Título deve ter pelo menos 5 caracteres';
                        }
                        return null;
                      },
                      maxLength: 100,
                    ),
                    
                    const SizedBox(height: AppDimensions.lg),
                    
                    // Body field
                    TextFormField(
                      controller: _bodyController,
                      decoration: const InputDecoration(
                        labelText: 'Conteúdo do Post',
                        hintText: 'Digite o conteúdo...',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Conteúdo é obrigatório';
                        }
                        if (value.trim().length < 10) {
                          return 'Conteúdo deve ter pelo menos 10 caracteres';
                        }
                        return null;
                      },
                      maxLines: 5,
                      maxLength: 500,
                    ),
                    
                    const SizedBox(height: AppDimensions.lg),
                    
                    // User ID field
                    TextFormField(
                      controller: _userIdController,
                      decoration: const InputDecoration(
                        labelText: 'ID do Usuário',
                        hintText: 'Digite o ID do usuário (1-10)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'ID do usuário é obrigatório';
                        }
                        final id = int.tryParse(value.trim());
                        if (id == null || id < 1 || id > 10) {
                          return 'ID deve ser um número entre 1 e 10';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppDimensions.xl),
            
            // Submit button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Criar Post',
                onPressed: _isLoading ? null : _submitForm,
                isLoading: _isLoading,
                icon: Icons.send,
                variant: CustomButtonVariant.primary,
                size: CustomButtonSize.large,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = CreatePostRequest(
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        userId: int.parse(_userIdController.text.trim()),
      );

      final createdPost = await ApiService.createPost(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomTypography.bodyMedium(
              text: 'Post criado com sucesso! ID: ${createdPost.id}',
              color: AppColors.background,
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Clear form
        _titleController.clear();
        _bodyController.clear();
        _userIdController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomTypography.bodyMedium(
              text: 'Erro ao criar post: $e',
              color: AppColors.background,
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}