import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/announcements/domain/repositories/announcement_repository.dart';

/// Use Case para deletar um anúncio
class DeleteAnnouncement {
  final AnnouncementRepository repository;

  DeleteAnnouncement(this.repository);

  Future<Either<Failure, void>> call(DeleteAnnouncementParams params) async {
    return await repository.deleteAnnouncement(params.id);
  }
}

/// Parâmetros para deletar um anúncio
class DeleteAnnouncementParams extends Equatable {
  final String id;

  const DeleteAnnouncementParams({required this.id});

  @override
  List<Object?> get props => [id];
}
