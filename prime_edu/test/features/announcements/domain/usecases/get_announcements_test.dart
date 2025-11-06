import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prime_edu/features/announcements/domain/entities/announcement_entity.dart';
import 'package:prime_edu/features/announcements/domain/repositories/announcement_repository.dart';
import 'package:prime_edu/features/announcements/domain/usecases/get_announcements.dart';

class MockAnnouncementRepository extends Mock implements AnnouncementRepository {}

void main() {
  late GetAnnouncements useCase;
  late MockAnnouncementRepository mockRepository;

  setUp(() {
    mockRepository = MockAnnouncementRepository();
    useCase = GetAnnouncements(mockRepository);
  });

  final tAnnouncements = [
    AnnouncementEntity(
      id: '1',
      title: 'Test Announcement',
      content: 'Test Content',
      teacherId: 'teacher1',
      teacherName: 'Teacher Name',
      priority: AnnouncementPriority.medium,
      type: AnnouncementType.geral,
      createdAt: DateTime(2024, 1, 1),
    ),
  ];

  test('deve obter lista de anúncios do repositório', () async {
    // arrange
    when(() => mockRepository.getAnnouncements())
        .thenAnswer((_) async => Right(tAnnouncements));

    // act
    final result = await useCase();

    // assert
    expect(result, Right(tAnnouncements));
    verify(() => mockRepository.getAnnouncements()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
