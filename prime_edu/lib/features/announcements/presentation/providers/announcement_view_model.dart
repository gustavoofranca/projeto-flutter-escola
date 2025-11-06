import 'package:flutter/foundation.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/announcements/domain/entities/announcement_entity.dart';
import 'package:prime_edu/features/announcements/domain/usecases/create_announcement.dart';
import 'package:prime_edu/features/announcements/domain/usecases/delete_announcement.dart';
import 'package:prime_edu/features/announcements/domain/usecases/get_announcements.dart';
import 'package:prime_edu/features/announcements/domain/usecases/get_urgent_announcements.dart';
import 'package:prime_edu/features/announcements/domain/usecases/update_announcement.dart';
import 'package:prime_edu/features/announcements/presentation/state/announcement_state.dart';

/// ViewModel para gerenciamento de anúncios usando estado imutável
/// 
/// Implementa o padrão MVVM com Clean Architecture:
/// - Estado imutável (AnnouncementState com Freezed)
/// - Separação de responsabilidades
/// - Testabilidade aprimorada
/// - Melhor rastreamento de mudanças de estado
class AnnouncementViewModel extends ChangeNotifier {
  final GetAnnouncements _getAnnouncementsUseCase;
  final GetUrgentAnnouncements _getUrgentAnnouncementsUseCase;
  final CreateAnnouncement _createAnnouncementUseCase;
  final UpdateAnnouncement _updateAnnouncementUseCase;
  final DeleteAnnouncement _deleteAnnouncementUseCase;

  // Estado privado imutável
  AnnouncementState _state = AnnouncementState.initial();

  // Getter público para o estado
  AnnouncementState get state => _state;

  // Getters de conveniência (mantém compatibilidade com código existente)
  bool get isLoading => _state.isLoading;
  String? get error => _state.error;
  List<AnnouncementEntity> get announcements => _state.announcements;
  bool get isLoaded => _state.isLoaded;

  AnnouncementViewModel({
    required GetAnnouncements getAnnouncementsUseCase,
    required GetUrgentAnnouncements getUrgentAnnouncementsUseCase,
    required CreateAnnouncement createAnnouncementUseCase,
    required UpdateAnnouncement updateAnnouncementUseCase,
    required DeleteAnnouncement deleteAnnouncementUseCase,
  })  : _getAnnouncementsUseCase = getAnnouncementsUseCase,
        _getUrgentAnnouncementsUseCase = getUrgentAnnouncementsUseCase,
        _createAnnouncementUseCase = createAnnouncementUseCase,
        _updateAnnouncementUseCase = updateAnnouncementUseCase,
        _deleteAnnouncementUseCase = deleteAnnouncementUseCase;

  /// Atualiza o estado de forma imutável
  void _updateState(AnnouncementState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();

      // Log para debug (pode ser removido em produção)
      if (kDebugMode) {
        debugPrint('[AnnouncementViewModel] State updated: ${newState.toString()}');
      }
    }
  }

  /// Carrega todos os anúncios
  Future<void> loadAnnouncements() async {
    _updateState(_state.copyWith(
      isLoading: true,
      error: null,
    ));

    try {
      final result = await _getAnnouncementsUseCase();

      result.fold(
        (failure) {
          _updateState(_state.copyWith(
            isLoading: false,
            error: _mapFailureToMessage(failure),
            isLoaded: false,
          ));
        },
        (announcements) {
          _updateState(_state.copyWith(
            isLoading: false,
            announcements: announcements,
            isLoaded: true,
            error: null,
          ));
        },
      );
    } catch (e) {
      _updateState(_state.copyWith(
        isLoading: false,
        error: 'Erro inesperado: ${e.toString()}',
        isLoaded: false,
      ));
    }
  }

  /// Carrega anúncios urgentes
  Future<void> loadUrgentAnnouncements() async {
    _updateState(_state.copyWith(
      isLoading: true,
      error: null,
      filter: AnnouncementFilter.urgent,
    ));

    try {
      final result = await _getUrgentAnnouncementsUseCase();

      result.fold(
        (failure) {
          _updateState(_state.copyWith(
            isLoading: false,
            error: _mapFailureToMessage(failure),
            isLoaded: false,
          ));
        },
        (announcements) {
          _updateState(_state.copyWith(
            isLoading: false,
            announcements: announcements,
            isLoaded: true,
            error: null,
          ));
        },
      );
    } catch (e) {
      _updateState(_state.copyWith(
        isLoading: false,
        error: 'Erro inesperado: ${e.toString()}',
        isLoaded: false,
      ));
    }
  }

  /// Cria um novo anúncio
  Future<bool> createAnnouncement(AnnouncementEntity announcement) async {
    _updateState(_state.copyWith(
      isLoading: true,
      error: null,
    ));

    try {
      final result = await _createAnnouncementUseCase(
        CreateAnnouncementParams(announcement: announcement),
      );

      return result.fold(
        (failure) {
          _updateState(_state.copyWith(
            isLoading: false,
            error: _mapFailureToMessage(failure),
          ));
          return false;
        },
        (newAnnouncement) {
          // Adiciona o novo anúncio à lista
          final updatedList = [..._state.announcements, newAnnouncement];
          _updateState(_state.copyWith(
            isLoading: false,
            announcements: updatedList,
            error: null,
          ));
          return true;
        },
      );
    } catch (e) {
      _updateState(_state.copyWith(
        isLoading: false,
        error: 'Erro inesperado: ${e.toString()}',
      ));
      return false;
    }
  }

  /// Atualiza um anúncio existente
  Future<bool> updateAnnouncement(AnnouncementEntity announcement) async {
    _updateState(_state.copyWith(
      isLoading: true,
      error: null,
    ));

    try {
      final result = await _updateAnnouncementUseCase(
        UpdateAnnouncementParams(announcement: announcement),
      );

      return result.fold(
        (failure) {
          _updateState(_state.copyWith(
            isLoading: false,
            error: _mapFailureToMessage(failure),
          ));
          return false;
        },
        (updatedAnnouncement) {
          // Atualiza o anúncio na lista
          final updatedList = _state.announcements.map((a) {
            return a.id == updatedAnnouncement.id ? updatedAnnouncement : a;
          }).toList();
          
          _updateState(_state.copyWith(
            isLoading: false,
            announcements: updatedList,
            error: null,
          ));
          return true;
        },
      );
    } catch (e) {
      _updateState(_state.copyWith(
        isLoading: false,
        error: 'Erro inesperado: ${e.toString()}',
      ));
      return false;
    }
  }

  /// Deleta um anúncio
  Future<bool> deleteAnnouncement(String id) async {
    _updateState(_state.copyWith(
      isLoading: true,
      error: null,
    ));

    try {
      final result = await _deleteAnnouncementUseCase(
        DeleteAnnouncementParams(id: id),
      );

      return result.fold(
        (failure) {
          _updateState(_state.copyWith(
            isLoading: false,
            error: _mapFailureToMessage(failure),
          ));
          return false;
        },
        (_) {
          // Remove o anúncio da lista
          final updatedList = _state.announcements.where((a) => a.id != id).toList();
          
          _updateState(_state.copyWith(
            isLoading: false,
            announcements: updatedList,
            error: null,
          ));
          return true;
        },
      );
    } catch (e) {
      _updateState(_state.copyWith(
        isLoading: false,
        error: 'Erro inesperado: ${e.toString()}',
      ));
      return false;
    }
  }

  /// Filtra anúncios por turma
  List<AnnouncementEntity> getAnnouncementsForClass(String? classId) {
    if (classId == null) return _state.announcements;
    
    return _state.announcements
        .where((a) => a.classId == classId || a.classId == null)
        .toList();
  }

  /// Filtra anúncios por professor
  List<AnnouncementEntity> getAnnouncementsForTeacher(String teacherId) {
    return _state.announcements
        .where((a) => a.teacherId == teacherId)
        .toList();
  }

  /// Obtém anúncios urgentes da lista atual
  List<AnnouncementEntity> getUrgentAnnouncementsFromList() {
    return _state.announcements
        .where(
          (a) =>
              a.priority == AnnouncementPriority.urgent ||
              a.priority == AnnouncementPriority.high,
        )
        .toList();
  }

  /// Limpa a mensagem de erro
  void clearError() {
    _updateState(_state.copyWith(error: null));
  }

  /// Mapeia falhas para mensagens amigáveis ao usuário
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return 'Erro ao acessar dados locais: ${failure.message}';
    } else if (failure is NetworkFailure) {
      return 'Erro de conexão. Verifique sua internet.';
    } else {
      return 'Ocorreu um erro inesperado. Tente novamente mais tarde.';
    }
  }

  @override
  void dispose() {
    if (kDebugMode) {
      debugPrint('[AnnouncementViewModel] Disposed');
    }
    super.dispose();
  }
}
