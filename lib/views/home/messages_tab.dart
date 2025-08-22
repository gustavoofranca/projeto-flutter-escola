import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_dimensions.dart';

/// Tab de Mensagens - Sistema de chat e comunicação
class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Lista de conversas
            Expanded(
              child: _buildConversationsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar nova conversa
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        child: const Icon(Icons.message),
      ),
    );
  }

  /// Constrói o cabeçalho da tela de mensagens
  Widget _buildHeader() {
    return Container(
      padding: AppDimensions.screenPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mensagens',
            style: AppTextStyles.h1.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            'Mantenha contato com professores e colegas',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói a lista de conversas
  Widget _buildConversationsList() {
    return ListView(
      padding: AppDimensions.screenPadding,
      children: [
        _buildConversationItem(
          name: 'Prof. Maria Santos',
          lastMessage: 'Olá! Como está indo o projeto de matemática?',
          time: '14:30',
          unreadCount: 2,
          isOnline: true,
          avatar: 'MS',
          color: AppColors.primary,
        ),
        _buildConversationItem(
          name: 'Turma 3º Ano A',
          lastMessage: 'Lembrem-se da entrega do trabalho amanhã!',
          time: '12:15',
          unreadCount: 0,
          isOnline: false,
          avatar: '3A',
          color: AppColors.secondary,
        ),
        _buildConversationItem(
          name: 'João Pedro',
          lastMessage: 'Vamos estudar juntos hoje?',
          time: '10:45',
          unreadCount: 1,
          isOnline: true,
          avatar: 'JP',
          color: AppColors.accent,
        ),
        _buildConversationItem(
          name: 'Prof. Carlos Oliveira',
          lastMessage: 'Excelente trabalho na última atividade!',
          time: '09:20',
          unreadCount: 0,
          isOnline: false,
          avatar: 'CO',
          color: AppColors.primary,
        ),
        _buildConversationItem(
          name: 'Ana Clara',
          lastMessage: 'Você tem os exercícios de história?',
          time: 'Ontem',
          unreadCount: 0,
          isOnline: false,
          avatar: 'AC',
          color: AppColors.secondary,
        ),
        _buildConversationItem(
          name: 'Prof. Ana Costa',
          lastMessage: 'Não se esqueça da prova na próxima semana',
          time: 'Ontem',
          unreadCount: 0,
          isOnline: false,
          avatar: 'AC',
          color: AppColors.accent,
        ),
        _buildConversationItem(
          name: 'Lucas Silva',
          lastMessage: 'Vamos fazer o trabalho em grupo?',
          time: '2 dias',
          unreadCount: 0,
          isOnline: false,
          avatar: 'LS',
          color: AppColors.primary,
        ),
        _buildConversationItem(
          name: 'Prof. Roberto Lima',
          lastMessage: 'Parabéns pelo desempenho!',
          time: '3 dias',
          unreadCount: 0,
          isOnline: false,
          avatar: 'RL',
          color: AppColors.secondary,
        ),
      ],
    );
  }

  /// Constrói um item de conversa
  Widget _buildConversationItem({
    required String name,
    required String lastMessage,
    required String time,
    required int unreadCount,
    required bool isOnline,
    required String avatar,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppDimensions.md),
        leading: Stack(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: color,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  avatar,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.surface,
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              time,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimensions.xs),
            Row(
              children: [
                Expanded(
                  child: Text(
                    lastMessage,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (unreadCount > 0) ...[
                  const SizedBox(width: AppDimensions.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.background,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        onTap: () {
          // TODO: Implementar navegação para chat
        },
      ),
    );
  }
}
