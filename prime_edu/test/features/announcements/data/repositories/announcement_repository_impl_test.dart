import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prime_edu/core/errors/exceptions.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/announcements/data/datasources/announcement_local_data_source.dart';
import 'package:prime_edu/features/announcements/data/models/announcement_model.dart';
import 'package:prime_edu/features/announcements/data/repositories/announcement_repository_impl.dart';
import 'package:prime_edu/features/announcements/domain/entities/announcement_entity.dart';

class MockAnnouncementLocalDataSource extends Mock
    implements AnnouncementLocalDataSource {}

class FakeAnnouncementModel extends Fake implements AnnouncementModel {}

void main() {
  late AnnouncementRepositoryImpl repository;
  late MockAnnouncementLocalDataSource mockLocalDataSource;

  setUpAll(() {
    registerFallbackValue(FakeAnnouncementModel());
  });

  setUp(() {
    mockLocalDataSource = MockAnnouncementLocalDataSource();
    repository = AnnouncementRepositoryImpl(
      localDataSource: mockLocalDataSource,
    );
  });

  final tAnnouncementModel = AnnouncementModel(
    id: '1',
    title: 'Test Announcement',
    content: 'Test Content',
    teacherId: 'teacher1',
    teacherName: 'Teacher Name',
    priority: AnnouncementPriority.medium,
    type: AnnouncementType.geral,
    createdAt: DateTime(2024, 1, 1),
  );

  final List<AnnouncementModel> tAnnouncementsList = [tAnnouncementModel];

  group('getAnnouncements', () {
    test(
      'deve retornar lista de anúncios quando a chamada ao data source for bem-sucedida',
      () async {
        // arrange
        when(() => mockLocalDataSource.getCachedAnnouncements())
            .thenAnswer((_) async => tAnnouncementsList);

        // act
        final result = await repository.getAnnouncements();

        // assert
        expect(result, equals(Right(tAnnouncementsList)));
        verify(() => mockLocalDataSource.getCachedAnnouncements()).called(1);
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );

    test(
      'deve retornar CacheFailure quando CacheException for lançada',
      () async {
        // arrange
        when(() => mockLocalDataSource.getCachedAnnouncements())
            .thenThrow(CacheException(message: 'Erro no cache'));

        // act
        final result = await repository.getAnnouncements();

        // assert
        expect(
          result,
          equals(Left(CacheFailure(message: 'Erro no cache'))),
        );
        verify(() => mockLocalDataSource.getCachedAnnouncements()).called(1);
      },
    );

    test(
      'deve retornar ServerFailure quando uma exceção inesperada for lançada',
      () async {
        // arrange
        when(() => mockLocalDataSource.getCachedAnnouncements())
            .thenThrow(Exception('Erro inesperado'));

        // act
        final result = await repository.getAnnouncements();

        // assert
        expect(result, isA<Left>());
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, contains('Erro inesperado'));
          },
          (_) => fail('Deveria retornar Left'),
        );
      },
    );
  });

  group('getAnnouncementsByClass', () {
    final tClassId = 'class1';

    test(
      'deve retornar anúncios filtrados por turma',
      () async {
        // arrange
        final announcements = [
          AnnouncementModel(
            id: '1',
            title: 'Announcement 1',
            content: 'Content 1',
            teacherId: 'teacher1',
            teacherName: 'Teacher',
            classId: tClassId,
            priority: AnnouncementPriority.medium,
            type: AnnouncementType.geral,
            createdAt: DateTime(2024, 1, 1),
          ),
          AnnouncementModel(
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
          AnnouncementModel(
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

        when(() => mockLocalDataSource.getCachedAnnouncements())
            .thenAnswer((_) async => announcements);

        // act
        final result = await repository.getAnnouncementsByClass(tClassId);

        // assert
        result.fold(
          (_) => fail('Deveria retornar Right'),
          (filtered) {
            expect(filtered.length, 2); // class1 + geral
            expect(filtered.any((a) => a.id == '1'), true);
            expect(filtered.any((a) => a.id == '3'), true);
            expect(filtered.any((a) => a.id == '2'), false);
          },
        );
      },
    );
  });

  group('getAnnouncementsByTeacher', () {
    final tTeacherId = 'teacher1';

    test(
      'deve retornar anúncios filtrados por professor',
      () async {
        // arrange
        final announcements = [
          AnnouncementModel(
            id: '1',
            title: 'Announcement 1',
            content: 'Content 1',
            teacherId: tTeacherId,
            teacherName: 'Teacher 1',
            priority: AnnouncementPriority.medium,
            type: AnnouncementType.geral,
            createdAt: DateTime(2024, 1, 1),
          ),
          AnnouncementModel(
            id: '2',
            title: 'Announcement 2',
            content: 'Content 2',
            teacherId: 'teacher2',
            teacherName: 'Teacher 2',
            priority: AnnouncementPriority.medium,
            type: AnnouncementType.geral,
            createdAt: DateTime(2024, 1, 1),
          ),
        ];

        when(() => mockLocalDataSource.getCachedAnnouncements())
            .thenAnswer((_) async => announcements);

        // act
        final result = await repository.getAnnouncementsByTeacher(tTeacherId);

        // assert
        result.fold(
          (_) => fail('Deveria retornar Right'),
          (filtered) {
            expect(filtered.length, 1);
            expect(filtered.first.teacherId, tTeacherId);
          },
        );
      },
    );
  });

  group('getUrgentAnnouncements', () {
    test(
      'deve retornar apenas anúncios urgentes e de alta prioridade',
      () async {
        // arrange
        final announcements = [
          AnnouncementModel(
            id: '1',
            title: 'Urgent',
            content: 'Content',
            teacherId: 'teacher1',
            teacherName: 'Teacher',
            priority: AnnouncementPriority.urgent,
            type: AnnouncementType.urgente,
            createdAt: DateTime(2024, 1, 1),
          ),
          AnnouncementModel(
            id: '2',
            title: 'High',
            content: 'Content',
            teacherId: 'teacher1',
            teacherName: 'Teacher',
            priority: AnnouncementPriority.high,
            type: AnnouncementType.geral,
            createdAt: DateTime(2024, 1, 1),
          ),
          AnnouncementModel(
            id: '3',
            title: 'Medium',
            content: 'Content',
            teacherId: 'teacher1',
            teacherName: 'Teacher',
            priority: AnnouncementPriority.medium,
            type: AnnouncementType.geral,
            createdAt: DateTime(2024, 1, 1),
          ),
        ];

        when(() => mockLocalDataSource.getCachedAnnouncements())
            .thenAnswer((_) async => announcements);

        // act
        final result = await repository.getUrgentAnnouncements();

        // assert
        result.fold(
          (_) => fail('Deveria retornar Right'),
          (urgent) {
            expect(urgent.length, 2);
            expect(urgent.any((a) => a.id == '1'), true);
            expect(urgent.any((a) => a.id == '2'), true);
            expect(urgent.any((a) => a.id == '3'), false);
          },
        );
      },
    );
  });

  group('createAnnouncement', () {
    test(
      'deve criar um anúncio e retorná-lo',
      () async {
        // arrange
        final tAnnouncement = AnnouncementEntity(
          id: '1',
          title: 'New Announcement',
          content: 'Content',
          teacherId: 'teacher1',
          teacherName: 'Teacher',
          priority: AnnouncementPriority.medium,
          type: AnnouncementType.geral,
          createdAt: DateTime(2024, 1, 1),
        );

        when(() => mockLocalDataSource.cacheAnnouncement(any()))
            .thenAnswer((_) async => Future.value());

        // act
        final result = await repository.createAnnouncement(tAnnouncement);

        // assert
        expect(result, isA<Right>());
        result.fold(
          (_) => fail('Deveria retornar Right'),
          (announcement) {
            expect(announcement.id, tAnnouncement.id);
            expect(announcement.title, tAnnouncement.title);
          },
        );
        verify(() => mockLocalDataSource.cacheAnnouncement(any())).called(1);
      },
    );

    test(
      'deve retornar CacheFailure quando falhar ao criar',
      () async {
        // arrange
        final tAnnouncement = AnnouncementEntity(
          id: '1',
          title: 'New Announcement',
          content: 'Content',
          teacherId: 'teacher1',
          teacherName: 'Teacher',
          priority: AnnouncementPriority.medium,
          type: AnnouncementType.geral,
          createdAt: DateTime(2024, 1, 1),
        );

        when(() => mockLocalDataSource.cacheAnnouncement(any()))
            .thenThrow(CacheException(message: 'Erro ao salvar'));

        // act
        final result = await repository.createAnnouncement(tAnnouncement);

        // assert
        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure, isA<CacheFailure>()),
          (_) => fail('Deveria retornar Left'),
        );
      },
    );
  });

  group('updateAnnouncement', () {
    test(
      'deve atualizar um anúncio e retorná-lo',
      () async {
        // arrange
        final tAnnouncement = AnnouncementEntity(
          id: '1',
          title: 'Updated Announcement',
          content: 'Updated Content',
          teacherId: 'teacher1',
          teacherName: 'Teacher',
          priority: AnnouncementPriority.high,
          type: AnnouncementType.geral,
          createdAt: DateTime(2024, 1, 1),
        );

        when(() => mockLocalDataSource.updateCachedAnnouncement(any()))
            .thenAnswer((_) async => Future.value());

        // act
        final result = await repository.updateAnnouncement(tAnnouncement);

        // assert
        expect(result, isA<Right>());
        result.fold(
          (_) => fail('Deveria retornar Right'),
          (announcement) {
            expect(announcement.id, tAnnouncement.id);
            expect(announcement.title, tAnnouncement.title);
          },
        );
        verify(() => mockLocalDataSource.updateCachedAnnouncement(any()))
            .called(1);
      },
    );
  });

  group('deleteAnnouncement', () {
    test(
      'deve deletar um anúncio com sucesso',
      () async {
        // arrange
        final tId = '1';
        when(() => mockLocalDataSource.removeCachedAnnouncement(any()))
            .thenAnswer((_) async => Future.value());

        // act
        final result = await repository.deleteAnnouncement(tId);

        // assert
        expect(result, equals(const Right(null)));
        verify(() => mockLocalDataSource.removeCachedAnnouncement(tId))
            .called(1);
      },
    );

    test(
      'deve retornar CacheFailure quando falhar ao deletar',
      () async {
        // arrange
        final tId = '1';
        when(() => mockLocalDataSource.removeCachedAnnouncement(any()))
            .thenThrow(CacheException(message: 'Erro ao deletar'));

        // act
        final result = await repository.deleteAnnouncement(tId);

        // assert
        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure, isA<CacheFailure>()),
          (_) => fail('Deveria retornar Left'),
        );
      },
    );
  });

  group('getAnnouncementById', () {
    test(
      'deve retornar um anúncio específico por ID',
      () async {
        // arrange
        final tId = '1';
        when(() => mockLocalDataSource.getCachedAnnouncements())
            .thenAnswer((_) async => tAnnouncementsList);

        // act
        final result = await repository.getAnnouncementById(tId);

        // assert
        expect(result, isA<Right>());
        result.fold(
          (_) => fail('Deveria retornar Right'),
          (announcement) {
            expect(announcement.id, tId);
          },
        );
      },
    );

    test(
      'deve retornar CacheFailure quando o anúncio não for encontrado',
      () async {
        // arrange
        final tId = 'non_existent';
        when(() => mockLocalDataSource.getCachedAnnouncements())
            .thenAnswer((_) async => tAnnouncementsList);

        // act
        final result = await repository.getAnnouncementById(tId);

        // assert
        expect(result, isA<Left>());
        result.fold(
          (failure) {
            expect(failure, isA<CacheFailure>());
            expect(failure.message, contains('não encontrado'));
          },
          (_) => fail('Deveria retornar Left'),
        );
      },
    );
  });
}
