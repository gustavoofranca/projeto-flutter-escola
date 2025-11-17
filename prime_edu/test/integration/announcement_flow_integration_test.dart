import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/announcements/domain/entities/announcement_entity.dart';
import 'package:prime_edu/features/announcements/domain/repositories/announcement_repository.dart';
import 'package:prime_edu/features/announcements/domain/usecases/create_announcement.dart';
import 'package:prime_edu/features/announcements/domain/usecases/delete_announcement.dart';
import 'package:prime_edu/features/announcements/domain/usecases/get_announcements.dart';
import 'package:prime_edu/features/announcements/domain/usecases/get_urgent_announcements.dart';
import 'package:prime_edu/features/announcements/domain/usecases/update_announcement.dart';
import 'package:prime_edu/features/announcements/presentation/providers/announcement_view_model.dart';
import 'package:dartz/dartz.dart';

class MockAnnouncementRepository extends Mock
    implements AnnouncementRepository {}

class FakeAnnouncementEntity extends Fake implements AnnouncementEntity {}

class FakeCreateAnnouncementParams extends Fake
    implements CreateAnnouncementParams {}

class FakeUpdateAnnouncementParams extends Fake
    implements UpdateAnnouncementParams {}

class FakeDeleteAnnouncementParams extends Fake
    implements DeleteAnnouncementParams {}

/// Testes de integração para o fluxo completo de gerenciamento de anúncios
/// 
/// Estes testes verificam a integração entre:
/// - ViewModel
/// - Use Cases
/// - Repository (mockado)
void main() {
  late MockAnnouncementRepository mockRepository;
  late GetAnnouncements getAnnouncementsUseCase;
  late GetUrgentAnnouncements getUrgentAnnouncementsUseCase;
  late CreateAnnouncement createAnnouncementUseCase;
  late UpdateAnnouncement updateAnnouncementUseCase;
  late DeleteAnnouncement deleteAnnouncementUseCase;
  late AnnouncementViewModel viewModel;

  setUpAll(() {
    registerFallbackValue(FakeAnnouncementEntity());
    registerFallbackValue(FakeCreateAnnouncementParams());
    registerFallbackValue(FakeUpdateAnnouncementParams());
    registerFallbackValue(FakeDeleteAnnouncementParams());
  });

  setUp(() {
    mockRepository = MockAnnouncementRepository();
    getAnnouncementsUseCase = GetAnnouncements(mockRepository);
    getUrgentAnnouncementsUseCase = GetUrgentAnnouncements(mockRepository);
    createAnnouncementUseCase = CreateAnnouncement(mockRepository);
    updateAnnouncementUseCase = UpdateAnnouncement(mockRepository);
    deleteAnnouncementUseCase = DeleteAnnouncement(mockRepository);

    viewModel = AnnouncementViewModel(
      getAnnouncementsUseCase: getAnnouncementsUseCase,
      getUrgentAnnouncementsUseCase: getUrgentAnnouncementsUseCase,
      createAnnouncementUseCase: createAnnouncementUseCase,
      updateAnnouncementUseCase: updateAnnouncementUseCase,
      deleteAnnouncementUseCase: deleteAnnouncementUseCase,
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

  final tAnnouncementsList = [tAnnouncement];

  group('Fluxo de Carregamento de Anúncios', () {
    test(
      'deve carregar anúncios com sucesso do início ao fim',
      () async {
        // arrange
        when(() => mockRepository.getAnnouncements())
            .thenAnswer((_) async => Right(tAnnouncementsList));

        // Verifica estado inicial
        expect(viewModel.isLoaded, false);
        expect(viewModel.announcements, isEmpty);

        // act
        await viewModel.loadAnnouncements();

        // assert
        expect(viewModel.isLoaded, true);
        expect(viewModel.announcements, tAnnouncementsList);
        expect(viewModel.error, isNull);
        expect(viewModel.isLoading, false);

        verify(() => mockRepository.getAnnouncements()).called(1);
      },
    );

    test(
      'deve lidar com erro ao carregar anúncios',
      () async {
        // arrange
        when(() => mockRepository.getAnnouncements()).thenAnswer(
          (_) async => const Left(CacheFailure(message: 'Erro ao carregar')),
        );

        // act
        await viewModel.loadAnnouncements();

        // assert
        expect(viewModel.isLoaded, false);
        expect(viewModel.announcements, isEmpty);
        expect(viewModel.error, isNotNull);
        expect(viewModel.error, contains('Erro ao carregar'));
      },
    );
  });

  group('Fluxo de Criação de Anúncio', () {
    test(
      'deve criar anúncio e adicionar à lista com sucesso',
      () async {
        // arrange
        when(() => mockRepository.createAnnouncement(any()))
            .thenAnswer((_) async => Right(tAnnouncement));

        // Verifica estado inicial
        expect(viewModel.announcements, isEmpty);

        // act
        final result = await viewModel.createAnnouncement(tAnnouncement);

        // assert
        expect(result, true);
        expect(viewModel.announcements, contains(tAnnouncement));
        expect(viewModel.announcements.length, 1);
        expect(viewModel.error, isNull);

        verify(() => mockRepository.createAnnouncement(tAnnouncement))
            .called(1);
      },
    );

    test(
      'deve lidar com erro ao criar anúncio',
      () async {
        // arrange
        when(() => mockRepository.createAnnouncement(any())).thenAnswer(
          (_) async => const Left(CacheFailure(message: 'Erro ao criar')),
        );

        // act
        final result = await viewModel.createAnnouncement(tAnnouncement);

        // assert
        expect(result, false);
        expect(viewModel.announcements, isEmpty);
        expect(viewModel.error, isNotNull);
      },
    );
  });

  group('Fluxo de Atualização de Anúncio', () {
    test(
      'deve atualizar anúncio existente com sucesso',
      () async {
        // arrange - Primeiro carrega anúncios
        when(() => mockRepository.getAnnouncements())
            .thenAnswer((_) async => Right(tAnnouncementsList));
        await viewModel.loadAnnouncements();

        final updatedAnnouncement = AnnouncementEntity(
          id: '1',
          title: 'Updated Title',
          content: 'Updated Content',
          teacherId: 'teacher1',
          teacherName: 'Teacher Name',
          priority: AnnouncementPriority.high,
          type: AnnouncementType.geral,
          createdAt: DateTime(2024, 1, 1),
        );

        when(() => mockRepository.updateAnnouncement(any()))
            .thenAnswer((_) async => Right(updatedAnnouncement));

        // act
        final result = await viewModel.updateAnnouncement(updatedAnnouncement);

        // assert
        expect(result, true);
        expect(viewModel.announcements.first.title, 'Updated Title');
        expect(viewModel.announcements.first.priority, AnnouncementPriority.high);
        expect(viewModel.error, isNull);
      },
    );
  });

  group('Fluxo de Exclusão de Anúncio', () {
    test(
      'deve deletar anúncio e remover da lista com sucesso',
      () async {
        // arrange - Primeiro carrega anúncios
        when(() => mockRepository.getAnnouncements())
            .thenAnswer((_) async => Right(tAnnouncementsList));
        await viewModel.loadAnnouncements();

        expect(viewModel.announcements.length, 1);

        when(() => mockRepository.deleteAnnouncement(any()))
            .thenAnswer((_) async => const Right(null));

        // act
        final result = await viewModel.deleteAnnouncement('1');

        // assert
        expect(result, true);
        expect(viewModel.announcements, isEmpty);
        expect(viewModel.error, isNull);

        verify(() => mockRepository.deleteAnnouncement('1')).called(1);
      },
    );

    test(
      'deve lidar com erro ao deletar anúncio',
      () async {
        // arrange
        when(() => mockRepository.deleteAnnouncement(any())).thenAnswer(
          (_) async => const Left(CacheFailure(message: 'Erro ao deletar')),
        );

        // act
        final result = await viewModel.deleteAnnouncement('1');

        // assert
        expect(result, false);
        expect(viewModel.error, isNotNull);
      },
    );
  });

  group('Fluxo de Filtragem de Anúncios', () {
    test(
      'deve filtrar anúncios por turma corretamente',
      () async {
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

        when(() => mockRepository.getAnnouncements())
            .thenAnswer((_) async => Right(announcements));

        await viewModel.loadAnnouncements();

        // act
        final filtered = viewModel.getAnnouncementsForClass('class1');

        // assert
        expect(filtered.length, 2); // class1 + geral
        expect(filtered.any((a) => a.id == '1'), true);
        expect(filtered.any((a) => a.id == '3'), true);
        expect(filtered.any((a) => a.id == '2'), false);
      },
    );

    test(
      'deve filtrar anúncios urgentes corretamente',
      () async {
        // arrange
        final announcements = [
          AnnouncementEntity(
            id: '1',
            title: 'Urgent',
            content: 'Content',
            teacherId: 'teacher1',
            teacherName: 'Teacher',
            priority: AnnouncementPriority.urgent,
            type: AnnouncementType.urgente,
            createdAt: DateTime(2024, 1, 1),
          ),
          AnnouncementEntity(
            id: '2',
            title: 'High',
            content: 'Content',
            teacherId: 'teacher1',
            teacherName: 'Teacher',
            priority: AnnouncementPriority.high,
            type: AnnouncementType.geral,
            createdAt: DateTime(2024, 1, 1),
          ),
          AnnouncementEntity(
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

        when(() => mockRepository.getAnnouncements())
            .thenAnswer((_) async => Right(announcements));

        await viewModel.loadAnnouncements();

        // act
        final urgent = viewModel.getUrgentAnnouncementsFromList();

        // assert
        expect(urgent.length, 2);
        expect(urgent.any((a) => a.priority == AnnouncementPriority.urgent), true);
        expect(urgent.any((a) => a.priority == AnnouncementPriority.high), true);
      },
    );
  });

  group('Fluxo de CRUD Completo', () {
    test(
      'deve executar operações CRUD em sequência com sucesso',
      () async {
        // 1. CREATE
        when(() => mockRepository.createAnnouncement(any()))
            .thenAnswer((_) async => Right(tAnnouncement));

        final createResult = await viewModel.createAnnouncement(tAnnouncement);
        expect(createResult, true);
        expect(viewModel.announcements.length, 1);

        // 2. READ (já está na lista)
        expect(viewModel.announcements.first.id, '1');

        // 3. UPDATE
        final updatedAnnouncement = AnnouncementEntity(
          id: '1',
          title: 'Updated',
          content: 'Updated Content',
          teacherId: 'teacher1',
          teacherName: 'Teacher Name',
          priority: AnnouncementPriority.high,
          type: AnnouncementType.geral,
          createdAt: DateTime(2024, 1, 1),
        );

        when(() => mockRepository.updateAnnouncement(any()))
            .thenAnswer((_) async => Right(updatedAnnouncement));

        final updateResult =
            await viewModel.updateAnnouncement(updatedAnnouncement);
        expect(updateResult, true);
        expect(viewModel.announcements.first.title, 'Updated');

        // 4. DELETE
        when(() => mockRepository.deleteAnnouncement(any()))
            .thenAnswer((_) async => const Right(null));

        final deleteResult = await viewModel.deleteAnnouncement('1');
        expect(deleteResult, true);
        expect(viewModel.announcements, isEmpty);
      },
    );
  });

  group('Fluxo de Gerenciamento de Estado', () {
    test(
      'deve gerenciar transições de estado durante operações',
      () async {
        // arrange
        final states = <bool>[];

        when(() => mockRepository.getAnnouncements()).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return Right(tAnnouncementsList);
        });

        // act & assert
        final future = viewModel.loadAnnouncements();

        states.add(viewModel.isLoading);
        expect(viewModel.isLoading, true);

        await future;

        states.add(viewModel.isLoading);
        expect(viewModel.isLoading, false);
        expect(viewModel.isLoaded, true);

        expect(states, [true, false]);
      },
    );

    test(
      'deve limpar erro quando solicitado',
      () async {
        // arrange - Cria um erro
        when(() => mockRepository.getAnnouncements()).thenAnswer(
          (_) async => const Left(CacheFailure(message: 'Erro')),
        );

        await viewModel.loadAnnouncements();
        expect(viewModel.error, isNotNull);

        // act
        viewModel.clearError();

        // assert
        expect(viewModel.error, isNull);
      },
    );
  });
}
