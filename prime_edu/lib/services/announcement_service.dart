import '../models/announcement_model.dart';
import '../models/user_model.dart';

/// Serviço para gerenciar avisos/anúncios
class AnnouncementService {
  static final AnnouncementService _instance = AnnouncementService._internal();
  factory AnnouncementService() => _instance;
  AnnouncementService._internal();

  // Simulação de dados (substituir por API real)
  static final List<AnnouncementModel> _mockAnnouncements = [
    AnnouncementModel(
      id: '1',
      title: 'Prova de Matemática - Próxima Terça',
      content: 'Lembrete: A prova de matemática sobre funções trigonométricas será na próxima terça-feira, 10/09. Estudem os capítulos 5 e 6 do livro. Boa sorte!',
      teacherId: '2',
      teacherName: 'Profa. Maria Santos',
      classId: 'mat_3a',
      className: 'Matemática - 3º A',
      priority: AnnouncementPriority.high,
      type: AnnouncementType.prova,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    ),
    AnnouncementModel(
      id: '2',
      title: 'Material para Laboratório de Química',
      content: 'Para a próxima aula prática, tragam: jaleco, óculos de proteção e caderno de anotações. O experimento será sobre reações ácido-base.',
      teacherId: '3',
      teacherName: 'Prof. Carlos Lima',
      classId: 'qui_2b',
      className: 'Química - 2º B',
      priority: AnnouncementPriority.medium,
      type: AnnouncementType.lembrete,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    AnnouncementModel(
      id: '3',
      title: 'Projeto de História - Entrega Adiada',
      content: 'O projeto sobre a República Velha teve sua entrega adiada para 20/09. Aproveitem o tempo extra para pesquisar mais fontes e melhorar a apresentação.',
      teacherId: '4',
      teacherName: 'Profa. Ana Costa',
      classId: 'his_2a',
      className: 'História - 2º A',
      priority: AnnouncementPriority.medium,
      type: AnnouncementType.tarefa,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    AnnouncementModel(
      id: '4',
      title: 'Feira de Ciências 2024',
      content: 'Inscrições abertas para a Feira de Ciências! Data: 15 de outubro. Temas relacionados à sustentabilidade e tecnologia. Formulário de inscrição na secretaria.',
      teacherId: '2',
      teacherName: 'Prof. João Silva',
      priority: AnnouncementPriority.low,
      type: AnnouncementType.evento,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    ),
    AnnouncementModel(
      id: '5',
      title: 'URGENTE: Mudança de Horário - Física',
      content: 'A aula de física de amanhã (06/09) foi transferida das 14h para 16h devido à reunião pedagógica. Local permanece o mesmo (Lab. 3).',
      teacherId: '5',
      teacherName: 'Prof. Roberto Alves',
      classId: 'fis_3b',
      className: 'Física - 3º B',
      priority: AnnouncementPriority.urgent,
      type: AnnouncementType.urgente,
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    ),
    AnnouncementModel(
      id: '6',
      title: 'Biblioteca - Novos Livros Disponíveis',
      content: 'A biblioteca recebeu novos exemplares de literatura brasileira contemporânea. Venham conferir as obras de Conceição Evaristo, Itamar Vieira Junior e outros.',
      teacherId: '6',
      teacherName: 'Profa. Letícia Ferreira',
      priority: AnnouncementPriority.low,
      type: AnnouncementType.geral,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    AnnouncementModel(
      id: '7',
      title: 'Olimpíada de Matemática - Inscrições',
      content: 'Últimos dias para se inscrever na Olimpíada Brasileira de Matemática das Escolas Públicas (OBMEP). Data limite: 10/09. Procurem a coordenação.',
      teacherId: '2',
      teacherName: 'Profa. Maria Santos',
      priority: AnnouncementPriority.medium,
      type: AnnouncementType.evento,
      createdAt: DateTime.now().subtract(const Duration(hours: 18)),
      expiresAt: DateTime.now().add(const Duration(days: 5)),
    ),
  ];

  /// Obtém todos os anúncios (filtrados por usuário se necessário)
  Future<List<AnnouncementModel>> getAnnouncements({
    UserModel? user,
    AnnouncementType? type,
    AnnouncementPriority? priority,
    bool onlyActive = true,
  }) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 800));

    List<AnnouncementModel> announcements = List.from(_mockAnnouncements);

    // Filtrar apenas anúncios ativos
    if (onlyActive) {
      announcements = announcements.where((a) => a.isValid).toList();
    }

    // Filtrar por tipo
    if (type != null) {
      announcements = announcements.where((a) => a.type == type).toList();
    }

    // Filtrar por prioridade
    if (priority != null) {
      announcements = announcements.where((a) => a.priority == priority).toList();
    }

    // Se for estudante, filtrar por turmas (simulação)
    if (user != null && user.userType == UserType.student) {
      // Para demo, mostrar todos os anúncios
      // Em uma implementação real, filtraria pelas turmas do aluno
    }

    // Ordenar por data de criação (mais recentes primeiro)
    announcements.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return announcements;
  }

  /// Obtém anúncios por prioridade urgente
  Future<List<AnnouncementModel>> getUrgentAnnouncements({UserModel? user}) async {
    final announcements = await getAnnouncements(user: user);
    return announcements
        .where((a) => a.priority == AnnouncementPriority.urgent)
        .toList();
  }

  /// Obtém anúncios recentes (últimas 24 horas)
  Future<List<AnnouncementModel>> getRecentAnnouncements({UserModel? user}) async {
    final announcements = await getAnnouncements(user: user);
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    
    return announcements
        .where((a) => a.createdAt.isAfter(yesterday))
        .toList();
  }

  /// Cria novo anúncio (apenas professores)
  Future<bool> createAnnouncement(AnnouncementModel announcement, UserModel user) async {
    if (user.userType != UserType.teacher && user.userType != UserType.admin) {
      throw Exception('Apenas professores e administradores podem criar anúncios');
    }

    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 500));

    // Adiciona à lista mock
    _mockAnnouncements.insert(0, announcement.copyWith(
      createdAt: DateTime.now(),
    ));

    return true;
  }

  /// Atualiza anúncio
  Future<bool> updateAnnouncement(AnnouncementModel announcement, UserModel user) async {
    if (user.userType != UserType.teacher && user.userType != UserType.admin) {
      throw Exception('Apenas professores e administradores podem editar anúncios');
    }

    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockAnnouncements.indexWhere((a) => a.id == announcement.id);
    if (index != -1) {
      _mockAnnouncements[index] = announcement.copyWith(
        updatedAt: DateTime.now(),
      );
      return true;
    }

    return false;
  }

  /// Remove anúncio
  Future<bool> deleteAnnouncement(String announcementId, UserModel user) async {
    if (user.userType != UserType.teacher && user.userType != UserType.admin) {
      throw Exception('Apenas professores e administradores podem excluir anúncios');
    }

    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockAnnouncements.indexWhere((a) => a.id == announcementId);
    if (index != -1) {
      _mockAnnouncements.removeAt(index);
      return true;
    }

    return false;
  }

  /// Obtém estatísticas de anúncios
  Future<Map<String, int>> getAnnouncementStats({UserModel? user}) async {
    final announcements = await getAnnouncements(user: user, onlyActive: false);
    
    return {
      'total': announcements.length,
      'active': announcements.where((a) => a.isActive).length,
      'urgent': announcements.where((a) => a.priority == AnnouncementPriority.urgent).length,
      'recent': announcements.where((a) {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        return a.createdAt.isAfter(yesterday);
      }).length,
    };
  }

  /// Marca anúncio como lido (implementação futura)
  Future<void> markAsRead(String announcementId, UserModel user) async {
    // Implementação futura para tracking de leitura
    await Future.delayed(const Duration(milliseconds: 200));
  }

  /// Obtém anúncios não lidos (implementação futura)
  Future<List<AnnouncementModel>> getUnreadAnnouncements(UserModel user) async {
    // Por enquanto retorna todos os anúncios recentes
    return getRecentAnnouncements(user: user);
  }
}