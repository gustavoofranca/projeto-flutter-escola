import 'package:dartz/dartz.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/announcements/domain/entities/announcement_entity.dart';

/// Interface do repositório de anúncios
/// 
/// Define os contratos que a camada de dados deve implementar.
/// Retorna Either<Failure, T> para tratamento funcional de erros.
abstract class AnnouncementRepository {
  /// Obtém todos os anúncios
  Future<Either<Failure, List<AnnouncementEntity>>> getAnnouncements();

  /// Obtém anúncios filtrados por turma
  Future<Either<Failure, List<AnnouncementEntity>>> getAnnouncementsByClass(
    String classId,
  );

  /// Obtém anúncios filtrados por professor
  Future<Either<Failure, List<AnnouncementEntity>>> getAnnouncementsByTeacher(
    String teacherId,
  );

  /// Obtém anúncios urgentes
  Future<Either<Failure, List<AnnouncementEntity>>> getUrgentAnnouncements();

  /// Cria um novo anúncio
  Future<Either<Failure, AnnouncementEntity>> createAnnouncement(
    AnnouncementEntity announcement,
  );

  /// Atualiza um anúncio existente
  Future<Either<Failure, AnnouncementEntity>> updateAnnouncement(
    AnnouncementEntity announcement,
  );

  /// Deleta um anúncio
  Future<Either<Failure, void>> deleteAnnouncement(String id);

  /// Obtém um anúncio por ID
  Future<Either<Failure, AnnouncementEntity>> getAnnouncementById(String id);
}
