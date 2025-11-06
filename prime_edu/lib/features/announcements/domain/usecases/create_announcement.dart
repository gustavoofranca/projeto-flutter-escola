import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/announcements/domain/entities/announcement_entity.dart';
import 'package:prime_edu/features/announcements/domain/repositories/announcement_repository.dart';

/// Use Case para criar um novo anúncio
class CreateAnnouncement {
  final AnnouncementRepository repository;

  CreateAnnouncement(this.repository);

  Future<Either<Failure, AnnouncementEntity>> call(
    CreateAnnouncementParams params,
  ) async {
    return await repository.createAnnouncement(params.announcement);
  }
}

/// Parâmetros para criar um anúncio
class CreateAnnouncementParams extends Equatable {
  final AnnouncementEntity announcement;

  const CreateAnnouncementParams({required this.announcement});

  @override
  List<Object?> get props => [announcement];
}
