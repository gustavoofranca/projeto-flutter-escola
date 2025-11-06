import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/announcements/domain/entities/announcement_entity.dart';
import 'package:prime_edu/features/announcements/domain/usecases/create_announcement.dart';
import 'package:prime_edu/features/announcements/domain/usecases/delete_announcement.dart';
import 'package:prime_edu/features/announcements/domain/usecases/get_announcements.dart';
import 'package:prime_edu/features/announcements/domain/usecases/get_urgent_announcements.dart';
import 'package:prime_edu/features/announcements/domain/usecases/update_announcement.dart';
import 'package:prime_edu/features/announcements/presentation/providers/announcement_view_model.dart';

class MockGetAnnouncements extends Mock implements GetAnnouncements {}
class MockGetUrgentAnnouncements extends Mock implements GetUrgentAnnouncements {}
class MockCreateAnnouncement extends Mock implements CreateAnnouncement {}
class MockUpdateAnnouncement extends Mock implements UpdateAnnouncement {}
class MockDeleteAnnouncement extends Mock implements DeleteAnnouncement {}

// Fake classes para fallback values
class FakeCreateAnnouncementParams extends Fake implements CreateAnnouncementParams {}
class FakeUpdateAnnouncementParams extends Fake implements UpdateAnnouncementParams {}
class FakeDeleteAnnouncementParams extends Fake implements DeleteAnnouncementParams {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeCreateAnnouncementParams());
    registerFallbackValue(FakeUpdateAnnouncementParams());
    registerFallbackValue(FakeDeleteAnnouncementParams());
  });

  late AnnouncementViewModel viewModel;
  late MockGetAnnouncements mockGetAnnouncements;
  late MockGetUrgentAnnouncements mockGetUrgentAnnouncements;
  late MockCreateAnnouncement mockCreateAnnouncement;
  late MockUpdateAnnouncement mockUpdateAnnouncement;
  late MockDeleteAnnouncement mockDeleteAnnouncement;

  setUp(() {
    mockGetAnnouncements = MockGetAnnouncements();
    mockGetUrgentAnnouncements = MockGetUrgentAnnouncements();
    mockCreateAnnouncement = MockCreateAnnouncement();
    mockUpdateAnnouncement = MockUpdateAnnouncement();
    mockDeleteAnnouncement = MockDeleteAnnouncement();

    viewModel = AnnouncementViewModel(
      getAnnouncementsUseCase: mockGetAnnouncements,
      getUrgentAnnouncementsUseCase: mockGetUrgentAnnouncements,
      createAnnouncementUseCase: mockCreateAnnouncement,
      updateAnnouncementUseCase: mockUpdateAnnouncement,
      deleteAnnouncementUseCase: mockDeleteAnnouncement,
    );
  });

  final tAnnouncement = AnnouncementEntity(
    id: '1',
    title: 'Test Announcement',
    content: 'Test Content',
    teacherId: 'teacher1',
    teacherName: 'Teacher Name',
    priority: AnnouncementPriority.medium,
    type: AnnouncementType.geral,
    createdAt: DateTime(2024, 1, 1),
  );

  final tAnnouncements = [tAnnouncement];

  group('loadAnnouncements', () {
    test('deve atualizar estado para loading e depois loaded quando bem-sucedido', () async {
      // arrange
      when(() => mockGetAnnouncements()).thenAnswer((_) async => Right(tAnnouncements));

      // act
      final future = viewModel.loadAnnouncements();

      // assert - verifica estado intermediário
      expect(viewModel.state.isLoading, true);
      expect(viewModel.state.error, isNull);

      await future;

      // assert - verifica estado final
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.isLoaded, true);
      expect(viewModel.state.announcements, tAnnouncements);
      expect(viewModel.state.error, isNull);

      verify(() => mockGetAnnouncements()).called(1);
    });

    test('deve atualizar estado com erro quando falhar', () async {
      // arrange
      const failure = CacheFailure(message: 'Erro ao carregar');
      when(() => mockGetAnnouncements()).thenAnswer((_) async => const Left(failure));

      // act
      await viewModel.loadAnnouncements();

      // assert
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.isLoaded, false);
      expect(viewModel.state.error, isNotNull);
      expect(viewModel.state.announcements, isEmpty);

      verify(() => mockGetAnnouncements()).called(1);
    });
  });

  group('createAnnouncement', () {
    test('deve criar anúncio e adicionar à lista quando bem-sucedido', () async {
      // arrange
      when(() => mockCreateAnnouncement(any()))
          .thenAnswer((_) async => Right(tAnnouncement));

      // act
      final result = await viewModel.createAnnouncement(tAnnouncement);

      // assert
      expect(result, true);
      expect(viewModel.state.announcements, contains(tAnnouncement));
      expect(viewModel.state.error, isNull);

      verify(() => mockCreateAnnouncement(any(that: isA<CreateAnnouncementParams>()))).called(1);
    });

    test('deve retornar false e atualizar erro quando falhar', () async {
      // arrange
      const failure = CacheFailure(message: 'Erro ao criar');
      when(() => mockCreateAnnouncement(any()))
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await viewModel.createAnnouncement(tAnnouncement);

      // assert
      expect(result, false);
      expect(viewModel.state.error, isNotNull);

      verify(() => mockCreateAnnouncement(any(that: isA<CreateAnnouncementParams>()))).called(1);
    });
  });

  group('deleteAnnouncement', () {
    test('deve deletar anúncio e remover da lista quando bem-sucedido', () async {
      // arrange
      when(() => mockGetAnnouncements()).thenAnswer((_) async => Right(tAnnouncements));
      await viewModel.loadAnnouncements();

      when(() => mockDeleteAnnouncement(any()))
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await viewModel.deleteAnnouncement('1');

      // assert
      expect(result, true);
      expect(viewModel.state.announcements, isEmpty);
      expect(viewModel.state.error, isNull);

      verify(() => mockDeleteAnnouncement(any(that: isA<DeleteAnnouncementParams>()))).called(1);
    });

    test('deve retornar false e atualizar erro quando falhar', () async {
      // arrange
      const failure = CacheFailure(message: 'Erro ao deletar');
      when(() => mockDeleteAnnouncement(any()))
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await viewModel.deleteAnnouncement('1');

      // assert
      expect(result, false);
      expect(viewModel.state.error, isNotNull);

      verify(() => mockDeleteAnnouncement(any(that: isA<DeleteAnnouncementParams>()))).called(1);
    });
  });

  group('getAnnouncementsForClass', () {
    test('deve filtrar anúncios por turma', () async {
      // arrange
      final announcements = [
        AnnouncementEntity(
          id: '1',
          title: 'Announcement 1',
          content: 'Content 1',
          teacherId: 'teacher1',
          teacherName: 'Teacher',
          classId: 'class1',
          priority: AnnouncementPriority.medium,
          type: AnnouncementType.geral,
          createdAt: DateTime(2024, 1, 1),
        ),
        AnnouncementEntity(
          id: '2',
          title: 'Announcement 2',
          content: 'Content 2',
          teacherId: 'teacher1',
          teacherName: 'Teacher',
          classId: 'class2',
          priority: AnnouncementPriority.medium,
          type: AnnouncementType.geral,
          createdAt: DateTime(2024, 1, 1),
        ),
        AnnouncementEntity(
          id: '3',
          title: 'Announcement 3',
          content: 'Content 3',
          teacherId: 'teacher1',
          teacherName: 'Teacher',
          classId: null, // Anúncio geral
          priority: AnnouncementPriority.medium,
          type: AnnouncementType.geral,
          createdAt: DateTime(2024, 1, 1),
        ),
      ];

      when(() => mockGetAnnouncements()).thenAnswer((_) async => Right(announcements));
      await viewModel.loadAnnouncements();

      // act
      final filtered = viewModel.getAnnouncementsForClass('class1');

      // assert
      expect(filtered.length, 2); // class1 + geral
      expect(filtered.any((a) => a.id == '1'), true);
      expect(filtered.any((a) => a.id == '3'), true);
      expect(filtered.any((a) => a.id == '2'), false);
    });
  });
}
