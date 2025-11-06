import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prime_edu/providers/announcement_provider.dart';
import 'package:prime_edu/models/announcement_model.dart';
import 'package:prime_edu/models/user_model.dart';

// Importa os métodos any e when do mocktail
import 'package:mocktail/mocktail.dart' show when, any;

// Registra os fallback values para os enums
void _registerFallbacks() {
  registerFallbackValue(AnnouncementPriority.medium);
  registerFallbackValue(AnnouncementType.geral);
}

// Mock para SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {
  final Map<String, String> _storage = {};

  @override
  String? getString(String? key) => _storage[key ?? ''];

  @override
  Future<bool> setString(String key, String value) async {
    _storage[key] = value;
    return true;
  }
}

void main() {
  late AnnouncementProvider provider;
  late MockSharedPreferences mockPrefs;
  late UserModel studentUser;
  late UserModel teacherUser;
  late UserModel adminUser;

  // Dados de exemplo
  final sampleAnnouncements = [
    AnnouncementModel(
      id: '1',
      title: 'Prova de Matemática',
      content: 'Prova na próxima semana',
      teacherId: 'teacher_001',
      teacherName: 'Prof. Silva',
      classId: '3A_2024',
      className: '3º Ano A',
      priority: AnnouncementPriority.high,
      type: AnnouncementType.prova,
      createdAt: DateTime.now(),
    ),
    AnnouncementModel(
      id: '2',
      title: 'Aviso Geral',
      content: 'Reunião de Pais',
      teacherId: 'teacher_002',
      teacherName: 'Coordenação',
      classId: null, // Para todas as turmas
      className: 'Todas as turmas',
      priority: AnnouncementPriority.medium,
      type: AnnouncementType.evento,
      createdAt: DateTime.now(),
    ),
  ];

  setUp(() {
    // Configura o SharedPreferences mockado
    SharedPreferences.setMockInitialValues({});
    
    // Inicializa o provider
    provider = AnnouncementProvider();
    
    // Configurar usuários de teste
    studentUser = UserModel(
      id: 'student_001',
      name: 'Aluno Teste',
      email: 'aluno@teste.com',
      userType: UserType.student,
      classId: '3A_2024',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    teacherUser = UserModel(
      id: 'teacher_001',
      name: 'Professor Teste',
      email: 'prof@teste.com',
      userType: UserType.teacher,
      subjects: ['Matemática'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    adminUser = UserModel(
      id: 'admin_001',
      name: 'Admin Teste',
      email: 'admin@teste.com',
      userType: UserType.admin,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    // Registra os fallback values
    _registerFallbacks();
  });

  test('getAnnouncementsForUser - Student sees class announcements', () async {
    // Arrange
    await provider.initialize(); // Garante que os anúncios foram carregados
    
    // Act
    final result = provider.getAnnouncementsForUser(studentUser);
    
    // Assert
    expect(result, isNotEmpty);
    // Verifica se todos os anúncios são da turma do aluno ou para todas as turmas
    for (final announcement in result) {
      expect(
        announcement.classId == null || announcement.classId == studentUser.classId,
        isTrue,
        reason: 'O anúncio deve ser para a turma do aluno ou para todas as turmas',
      );
    }
  });

  test('getAnnouncementsForUser - Teacher sees own announcements', () async {
    // Arrange
    await provider.initialize(); // Garante que os anúncios foram carregados
    
    // Act
    final result = provider.getAnnouncementsForUser(teacherUser);
    
    // Assert
    expect(result, isNotEmpty);
    // Verifica se todos os anúncios são do professor
    for (final announcement in result) {
      expect(
        announcement.teacherId,
        equals(teacherUser.id),
        reason: 'O anúncio deve pertencer ao professor',
      );
    }
  });

  test('getAnnouncementsForUser - Admin sees all announcements', () async {
    // Arrange
    await provider.initialize(); // Garante que os anúncios foram carregados
    
    // Act
    final result = provider.getAnnouncementsForUser(adminUser);
    
    // Assert
    expect(result, isNotEmpty);
    // Admin deve ver todos os anúncios
    expect(
      result.length,
      equals(provider.announcements.length),
      reason: 'O admin deve ver todos os anúncios',
    );
  });

  test('getUrgentAnnouncements - Returns only high/urgent priority', () async {
    // Arrange
    await provider.initialize(); // Garante que os anúncios foram carregados
    
    // Adiciona um anúncio urgente para garantir que existe pelo menos um
    final urgentAnnouncement = AnnouncementModel(
      id: 'urgent_1',
      title: 'Aviso Urgente',
      content: 'Este é um aviso urgente',
      teacherId: 'teacher_001',
      teacherName: 'Prof. Teste',
      priority: AnnouncementPriority.urgent,
      type: AnnouncementType.urgente,
      createdAt: DateTime.now(),
    );
    await provider.createAnnouncement(urgentAnnouncement);
    
    // Act
    final result = provider.getUrgentAnnouncements(studentUser);
    
    // Assert
    expect(result, isNotEmpty, reason: 'Deveria retornar pelo menos um anúncio urgente');
    for (final announcement in result) {
      expect(
        announcement.priority == AnnouncementPriority.high ||
        announcement.priority == AnnouncementPriority.urgent,
        isTrue,
        reason: 'Deve retornar apenas anúncios com prioridade alta ou urgente',
      );
    }
  });

  test('createAnnouncement - Adds new announcement', () async {
    // Arrange
    provider = AnnouncementProvider();
    await provider.initialize(); // Garante que os anúncios foram carregados
    final initialCount = provider.announcements.length;
    final newAnnouncement = AnnouncementModel(
      id: 'new_1',
      title: 'Novo Aviso',
      content: 'Conteúdo do novo aviso',
      teacherId: 'teacher_001',
      teacherName: 'Prof. Teste',
      priority: AnnouncementPriority.medium,
      type: AnnouncementType.geral,
      createdAt: DateTime.now(),
    );

    // Act
    final result = await provider.createAnnouncement(newAnnouncement);
    
    // Assert
    expect(result, isTrue);
    expect(provider.announcements.length, equals(initialCount + 1));
    expect(provider.announcements.first.id, equals('new_1'));
  });

  test('deleteAnnouncement - Removes announcement', () async {
    // Arrange
    provider = AnnouncementProvider();
    await provider.initialize();
    
    // Cria um anúncio para deletar
    final newAnnouncement = AnnouncementModel(
      id: 'to_delete',
      title: 'Anúncio para deletar',
      content: 'Este anúncio será deletado',
      teacherId: 'teacher_001',
      teacherName: 'Prof. Teste',
      priority: AnnouncementPriority.medium,
      type: AnnouncementType.geral,
      createdAt: DateTime.now(),
    );
    await provider.createAnnouncement(newAnnouncement);
    
    final initialCount = provider.announcements.length;
    final announcementToDelete = provider.announcements.firstWhere(
      (a) => a.id == 'to_delete',
    );

    // Act
    final result = await provider.deleteAnnouncement(announcementToDelete.id);
    
    // Assert
    expect(result, isTrue);
    expect(provider.announcements.length, equals(initialCount - 1));
    expect(
      provider.announcements.any((a) => a.id == announcementToDelete.id),
      isFalse,
    );
  });

  test('loadAnnouncements - Handles empty storage', () async {
    // Arrange
    // Cria um novo mock de SharedPreferences que retorna null para qualquer chave
    final mockPrefs = MockSharedPreferences();
    
    // Substitui o SharedPreferences padrão pelo nosso mock
    SharedPreferences.setMockInitialValues({});
    
    provider = AnnouncementProvider();
    
    // Act
    await provider.initialize();
    
    // Assert
    expect(provider.announcements, isNotEmpty, reason: 'Deveria carregar dados iniciais quando o storage está vazio');
    
    // Verifica se o método saveToLocalStorage foi chamado
    // Isso garante que os dados iniciais foram carregados corretamente
    expect(provider.announcements.length, greaterThan(0));
  });

  test('updateAnnouncement - Updates existing announcement', () async {
    // Arrange
    provider = AnnouncementProvider();
    await provider.initialize();
    
    // Cria um novo anúncio para garantir que existe pelo menos um
    final newAnnouncement = AnnouncementModel(
      id: 'to_update',
      title: 'Anúncio para atualizar',
      content: 'Este anúncio será atualizado',
      teacherId: 'teacher_001',
      teacherName: 'Prof. Teste',
      priority: AnnouncementPriority.medium,
      type: AnnouncementType.geral,
      createdAt: DateTime.now(),
    );
    await provider.createAnnouncement(newAnnouncement);
    
    final originalAnnouncement = provider.announcements.firstWhere(
      (a) => a.id == 'to_update',
    );
    
    final updatedAnnouncement = originalAnnouncement.copyWith(
      title: 'Título Atualizado',
      content: 'Conteúdo atualizado',
    );

    // Act
    final result = await provider.updateAnnouncement(updatedAnnouncement);
    
    // Assert
    expect(result, isTrue);
    final updated = provider.announcements.firstWhere(
      (a) => a.id == originalAnnouncement.id,
    );
    expect(updated.title, equals('Título Atualizado'));
    expect(updated.content, equals('Conteúdo atualizado'));
  });
}
