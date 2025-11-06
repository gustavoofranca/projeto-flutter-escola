import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/announcements/domain/entities/announcement_entity.dart';
import 'package:prime_edu/features/announcements/domain/repositories/announcement_repository.dart';

/// Use Case para atualizar um anúncio
class UpdateAnnouncement {
  final AnnouncementRepository repository;

  UpdateAnnouncement(this.repository);

  Future<Either<Failure, AnnouncementEntity>> call(
    UpdateAnnouncementParams params,
  ) async {
    return await repository.updateAnnouncement(params.announcement);
  }
}

/// Parâmetros para atualizar um anúncio
class UpdateAnnouncementParams extends Equatable {
  final AnnouncementEntity announcement;

  const UpdateAnnouncementParams({required this.announcement});

  @override
  List<Object?> get props => [announcement];
}
