import 'package:dartz/dartz.dart';
import 'package:prime_edu/core/errors/exceptions.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/announcements/data/datasources/announcement_local_data_source.dart';
import 'package:prime_edu/features/announcements/data/models/announcement_model.dart';
import 'package:prime_edu/features/announcements/domain/entities/announcement_entity.dart';
import 'package:prime_edu/features/announcements/domain/repositories/announcement_repository.dart';

/// Implementação do repositório de anúncios
/// 
/// Coordena entre data sources e converte exceções em Failures.
/// Implementa a lógica de cache e fallback.
class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementLocalDataSource localDataSource;

  AnnouncementRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<AnnouncementEntity>>> getAnnouncements() async {
    try {
      final announcements = await localDataSource.getCachedAnnouncements();
      return Right(announcements);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Erro inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AnnouncementEntity>>> getAnnouncementsByClass(
    String classId,
  ) async {
    try {
      final announcements = await localDataSource.getCachedAnnouncements();
      final filtered = announcements
          .where((a) => a.classId == classId || a.classId == null)
          .toList();
      return Right(filtered);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Erro inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AnnouncementEntity>>> getAnnouncementsByTeacher(
    String teacherId,
  ) async {
    try {
      final announcements = await localDataSource.getCachedAnnouncements();
      final filtered =
          announcements.where((a) => a.teacherId == teacherId).toList();
      return Right(filtered);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Erro inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AnnouncementEntity>>>
      getUrgentAnnouncements() async {
    try {
      final announcements = await localDataSource.getCachedAnnouncements();
      final urgent = announcements
          .where(
            (a) =>
                a.priority == AnnouncementPriority.urgent ||
                a.priority == AnnouncementPriority.high,
          )
          .toList();
      return Right(urgent);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Erro inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, AnnouncementEntity>> createAnnouncement(
    AnnouncementEntity announcement,
  ) async {
    try {
      final model = AnnouncementModel.fromEntity(announcement);
      await localDataSource.cacheAnnouncement(model);
      return Right(model);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Erro inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, AnnouncementEntity>> updateAnnouncement(
    AnnouncementEntity announcement,
  ) async {
    try {
      final model = AnnouncementModel.fromEntity(announcement);
      await localDataSource.updateCachedAnnouncement(model);
      return Right(model);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Erro inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAnnouncement(String id) async {
    try {
      await localDataSource.removeCachedAnnouncement(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Erro inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, AnnouncementEntity>> getAnnouncementById(
    String id,
  ) async {
    try {
      final announcements = await localDataSource.getCachedAnnouncements();
      final announcement = announcements.firstWhere(
        (a) => a.id == id,
        orElse: () => throw CacheException(message: 'Anúncio não encontrado'),
      );
      return Right(announcement);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Erro inesperado: $e'));
    }
  }
}
