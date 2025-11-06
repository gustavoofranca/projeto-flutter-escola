import 'package:dartz/dartz.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/announcements/domain/entities/announcement_entity.dart';
import 'package:prime_edu/features/announcements/domain/repositories/announcement_repository.dart';

/// Use Case para obter todos os anúncios
class GetAnnouncements {
  final AnnouncementRepository repository;

  GetAnnouncements(this.repository);

  Future<Either<Failure, List<AnnouncementEntity>>> call() async {
    return await repository.getAnnouncements();
  }
}
