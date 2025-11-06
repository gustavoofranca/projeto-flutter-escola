import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prime_edu/features/announcements/domain/entities/announcement_entity.dart';

part 'announcement_state.freezed.dart';

/// Estado imutável para gerenciamento de anúncios
/// 
/// Usa Freezed para gerar código boilerplate automaticamente:
/// - copyWith() para atualizações imutáveis
/// - Equality (==) e hashCode
/// - toString() para debug
@freezed
class AnnouncementState with _$AnnouncementState {
  const factory AnnouncementState({
    /// Indica se uma operação está em andamento
    @Default(false) bool isLoading,
    
    /// Lista de anúncios
    @Default([]) List<AnnouncementEntity> announcements,
    
    /// Mensagem de erro, se houver
    String? error,
    
    /// Indica se os dados foram carregados
    @Default(false) bool isLoaded,
    
    /// Filtro atual aplicado
    @Default(AnnouncementFilter.all) AnnouncementFilter filter,
  }) = _AnnouncementState;
  
  /// Estado inicial (não carregado, sem loading, sem erro)
  factory AnnouncementState.initial() => const AnnouncementState();
  
  /// Estado de loading
  factory AnnouncementState.loading() => const AnnouncementState(
        isLoading: true,
      );
  
  /// Estado carregado com sucesso
  factory AnnouncementState.loaded(List<AnnouncementEntity> announcements) =>
      AnnouncementState(
        isLoaded: true,
        announcements: announcements,
      );
  
  /// Estado com erro
  factory AnnouncementState.error(String message) => AnnouncementState(
        error: message,
      );
}

/// Filtros disponíveis para anúncios
enum AnnouncementFilter {
  all,
  urgent,
  byClass,
  byTeacher,
}
