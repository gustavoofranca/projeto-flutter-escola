import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/announcement_model.dart';
import '../models/user_model.dart';

/// Provider para gerenciar anúncios com estado persistente
class AnnouncementProvider extends ChangeNotifier {
  final List<AnnouncementModel> _announcements = [];
  bool _isLoading = false;
  String? _error;
  static const String _announcementsKey = 'announcements';

  List<AnnouncementModel> get announcements => _announcements;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize provider and load announcements from local storage
  Future<void> initialize() async {
    await loadAnnouncements();
  }

  /// Get announcements filtered by user
  List<AnnouncementModel> getAnnouncementsForUser(UserModel user) {
    if (user.userType == UserType.teacher) {
      // Teachers see only their announcements
      return _announcements.where((a) => a.teacherId == user.id).toList();
    } else if (user.userType == UserType.student) {
      // Students see announcements for their class
      return _announcements
          .where((a) => a.classId == user.classId || a.classId == null)
          .toList();
    } else {
      // Admins see all announcements
      return _announcements;
    }
  }

  /// Get urgent announcements
  List<AnnouncementModel> getUrgentAnnouncements(UserModel user) {
    return getAnnouncementsForUser(user)
        .where(
          (a) =>
              a.priority == AnnouncementPriority.urgent ||
              a.priority == AnnouncementPriority.high,
        )
        .toList();
  }

  /// Load announcements from local storage
  Future<void> loadAnnouncements() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final announcementsJson = prefs.getString(_announcementsKey);

      if (announcementsJson != null && announcementsJson.isNotEmpty) {
        final List<dynamic> decoded = json.decode(announcementsJson);
        _announcements.clear();
        _announcements.addAll(
          decoded.map((item) => AnnouncementModel.fromMap(item)).toList(),
        );
      } else {
        // Load initial mock data if no data exists
        await _loadInitialData();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar avisos: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load initial mock data
  Future<void> _loadInitialData() async {
    // Mock data - in real app, this would come from an API
    _announcements.clear();
    _announcements.addAll([
      AnnouncementModel(
        id: '1',
        title: 'Prova de Matemática - 3º Bimestre',
        content:
            'A prova será realizada na próxima segunda-feira, dia 28/08, às 14h. Conteúdo: Equações do 2º grau, função quadrática e sistemas lineares. Não esqueçam de trazer calculadora científica.',
        teacherId: 'teacher_001',
        teacherName: 'Prof. Ana Costa',
        classId: '3A_2024',
        className: '3º Ano A',
        priority: AnnouncementPriority.high,
        type: AnnouncementType.prova,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        attachmentUrls: ['https://example.com/formula-sheet.pdf'],
      ),
      AnnouncementModel(
        id: '2',
        title: 'Reunião de Pais e Mestres',
        content:
            'Reunião marcada para sexta-feira, 30/08, às 19h no auditório principal. Serão discutidos o desempenho da turma, projetos do próximo bimestre e esclarecimentos sobre o sistema de avaliação.',
        teacherId: 'teacher_002',
        teacherName: 'Coordenação Pedagógica',
        classId: null, // All classes
        className: 'Todas as turmas',
        priority: AnnouncementPriority.medium,
        type: AnnouncementType.evento,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      AnnouncementModel(
        id: '3',
        title: 'Trabalho de História - República Velha',
        content:
            'Entrega do trabalho sobre a República Velha no Brasil até quinta-feira, 01/09, às 23h59 via plataforma online. O trabalho deve ter no mínimo 8 páginas, incluir bibliografia e seguir as normas ABNT.',
        teacherId: 'teacher_002',
        teacherName: 'Prof. Carlos Oliveira',
        classId: '3A_2024',
        className: '3º Ano A',
        priority: AnnouncementPriority.medium,
        type: AnnouncementType.tarefa,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        expiresAt: DateTime.now().add(const Duration(days: 5)),
      ),
      AnnouncementModel(
        id: '4',
        title: 'URGENTE: Cancelamento de Aula',
        content:
            'A aula de Educação Física de hoje (25/08) foi cancelada devido às condições climáticas adversas. A reposição será agendada para a próxima terça-feira no mesmo horário.',
        teacherId: 'teacher_003',
        teacherName: 'Prof. Roberto Fitness',
        classId: '3A_2024',
        className: '3º Ano A',
        priority: AnnouncementPriority.urgent,
        type: AnnouncementType.urgente,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      AnnouncementModel(
        id: '5',
        title: 'Feira de Ciências 2024',
        content:
            'A Feira de Ciências será realizada no dia 15 de dezembro no ginásio da escola. Inscrições de projetos até 10/12. Categorias: Ciências da Natureza, Matemática, Tecnologia e Sustentabilidade.',
        teacherId: 'teacher_001',
        teacherName: 'Prof. Maria Ciência',
        classId: null,
        className: 'Todas as turmas',
        priority: AnnouncementPriority.low,
        type: AnnouncementType.evento,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        expiresAt: DateTime.now().add(const Duration(days: 120)),
      ),
      AnnouncementModel(
        id: '6',
        title: 'Lembrete: Entrega de Material',
        content:
            'Lembrete para todos os alunos: a entrega dos materiais de laboratório de Química deve ser feita até sexta-feira na sala dos professores. Verificar se todos os itens estão limpos e organizados.',
        teacherId: 'teacher_004',
        teacherName: 'Prof. Ana Química',
        classId: '3A_2024',
        className: '3º Ano A',
        priority: AnnouncementPriority.medium,
        type: AnnouncementType.lembrete,
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ]);

    // Save initial data to local storage
    await _saveToLocalStorage();
  }

  /// Save announcements to local storage
  Future<void> _saveToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> announcementsMap = _announcements
        .map((a) => a.toMap())
        .toList();
    final String jsonString = json.encode(announcementsMap);
    await prefs.setString(_announcementsKey, jsonString);
  }

  /// Create new announcement
  Future<bool> createAnnouncement(AnnouncementModel announcement) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Add new announcement
      _announcements.insert(0, announcement);

      // Save to local storage
      await _saveToLocalStorage();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Erro ao criar aviso: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update announcement
  Future<bool> updateAnnouncement(AnnouncementModel announcement) async {
    try {
      _isLoading = true;
      notifyListeners();

      final index = _announcements.indexWhere((a) => a.id == announcement.id);
      if (index != -1) {
        _announcements[index] = announcement.copyWith(
          updatedAt: DateTime.now(),
        );

        // Save to local storage
        await _saveToLocalStorage();

        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Erro ao atualizar aviso: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete announcement
  Future<bool> deleteAnnouncement(String announcementId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _announcements.removeWhere((a) => a.id == announcementId);

      // Save to local storage
      await _saveToLocalStorage();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Erro ao deletar aviso: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Mark announcement as read (for students)
  Future<void> markAsRead(String announcementId, String userId) async {
    // In a real app, this would update the read status in the backend
    await Future.delayed(const Duration(milliseconds: 200));
  }

  /// Get unread announcements count
  int getUnreadCount(UserModel user) {
    // Mock implementation - in real app this would come from backend
    return getAnnouncementsForUser(user)
        .where(
          (a) => a.createdAt.isAfter(
            DateTime.now().subtract(const Duration(days: 7)),
          ),
        )
        .length;
  }

  /// Filter announcements by type
  List<AnnouncementModel> filterByType(
    List<AnnouncementModel> announcements,
    AnnouncementType type,
  ) {
    return announcements.where((a) => a.type == type).toList();
  }

  /// Filter announcements by priority
  List<AnnouncementModel> filterByPriority(
    List<AnnouncementModel> announcements,
    AnnouncementPriority priority,
  ) {
    return announcements.where((a) => a.priority == priority).toList();
  }

  /// Search announcements
  List<AnnouncementModel> searchAnnouncements(
    List<AnnouncementModel> announcements,
    String query,
  ) {
    if (query.isEmpty) return announcements;

    final lowerQuery = query.toLowerCase();
    return announcements
        .where(
          (a) =>
              a.title.toLowerCase().contains(lowerQuery) ||
              a.content.toLowerCase().contains(lowerQuery) ||
              a.teacherName.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh announcements
  Future<void> refresh() async {
    await loadAnnouncements();
  }
}
