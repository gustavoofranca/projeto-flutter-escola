import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prime_edu/providers/announcement_provider.dart';
import 'package:prime_edu/models/announcement_model.dart';
import 'package:prime_edu/models/user_model.dart';

// Mock para SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {
  final Map<String, String> _storage = {};

  @override
  String? getString(String key) => _storage[key];

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
    mockPrefs = MockSharedPreferences();
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
  });

  test('getAnnouncementsForUser - Student sees class announcements', () {
    // Arrange
    provider = AnnouncementProvider();
    
    // Act
    final result = provider.getAnnouncementsForUser(studentUser);
    
    // Assert
    expect(result.length, greaterThan(0));
    // Verifica se todos os anúncios são da turma do aluno ou para todas as turmas
    for (final announcement in result) {
      expect(
        announcement.classId == null || announcement.classId == studentUser.classId,
        isTrue,
      );
    }
  });

  test('getAnnouncementsForUser - Teacher sees own announcements', () {
    // Arrange
    provider = AnnouncementProvider();
    
    // Act
    final result = provider.getAnnouncementsForUser(teacherUser);
    
    // Assert
    expect(result.length, greaterThan(0));
    // Verifica se todos os anúncios são do professor
    for (final announcement in result) {
      expect(announcement.teacherId, equals(teacherUser.id));
    }
  });

  test('getAnnouncementsForUser - Admin sees all announcements', () {
    // Arrange
    provider = AnnouncementProvider();
    
    // Act
    final result = provider.getAnnouncementsForUser(adminUser);
    
    // Assert
    expect(result.length, greaterThan(0));
    // Admin deve ver todos os anúncios
    expect(result.length, equals(provider.announcements.length));
  });

  test('getUrgentAnnouncements - Returns only high/urgent priority', () {
    // Arrange
    provider = AnnouncementProvider();
    
    // Act
    final result = provider.getUrgentAnnouncements(studentUser);
    
    // Assert
    for (final announcement in result) {
      expect(
        announcement.priority == AnnouncementPriority.high ||
        announcement.priority == AnnouncementPriority.urgent,
        isTrue,
      );
    }
  });

  test('createAnnouncement - Adds new announcement', () async {
    // Arrange
    provider = AnnouncementProvider();
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
    final initialCount = provider.announcements.length;
    final announcementToDelete = provider.announcements.first;

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
    SharedPreferences.setMockInitialValues({});
    provider = AnnouncementProvider();
    
    // Act
    await provider.initialize();
    
    // Assert
    expect(provider.announcements, isNotEmpty);
  });

  test('updateAnnouncement - Updates existing announcement', () async {
    // Arrange
    provider = AnnouncementProvider();
    await provider.initialize();
    final originalAnnouncement = provider.announcements.first;
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
