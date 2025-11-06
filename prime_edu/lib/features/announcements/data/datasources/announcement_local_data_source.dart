import 'package:prime_edu/features/announcements/data/models/announcement_model.dart';

/// Interface do Data Source local para anúncios
/// 
/// Define os contratos para acesso a dados locais (SharedPreferences, SQLite, etc).
/// Lança exceções em caso de erro (padrão Clean Architecture).
abstract class AnnouncementLocalDataSource {
  /// Obtém todos os anúncios do cache local
  Future<List<AnnouncementModel>> getCachedAnnouncements();

  /// Salva anúncios no cache local
  Future<void> cacheAnnouncements(List<AnnouncementModel> announcements);

  /// Adiciona um novo anúncio ao cache
  Future<void> cacheAnnouncement(AnnouncementModel announcement);

  /// Atualiza um anúncio no cache
  Future<void> updateCachedAnnouncement(AnnouncementModel announcement);

  /// Remove um anúncio do cache
  Future<void> removeCachedAnnouncement(String id);

  /// Limpa todo o cache de anúncios
  Future<void> clearCache();
}
