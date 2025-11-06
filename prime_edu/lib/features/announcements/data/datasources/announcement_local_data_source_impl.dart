import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prime_edu/core/errors/exceptions.dart';
import 'package:prime_edu/features/announcements/data/datasources/announcement_local_data_source.dart';
import 'package:prime_edu/features/announcements/data/models/announcement_model.dart';

/// Implementação do Data Source local usando SharedPreferences
class AnnouncementLocalDataSourceImpl implements AnnouncementLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _cacheKey = 'CACHED_ANNOUNCEMENTS';

  AnnouncementLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<AnnouncementModel>> getCachedAnnouncements() async {
    try {
      final jsonString = sharedPreferences.getString(_cacheKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => AnnouncementModel.fromMap(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Erro ao carregar anúncios do cache: $e');
    }
  }

  @override
  Future<void> cacheAnnouncements(List<AnnouncementModel> announcements) async {
    try {
      final jsonList = announcements.map((a) => a.toMap()).toList();
      final jsonString = json.encode(jsonList);
      await sharedPreferences.setString(_cacheKey, jsonString);
    } catch (e) {
      throw CacheException(message: 'Erro ao salvar anúncios no cache: $e');
    }
  }

  @override
  Future<void> cacheAnnouncement(AnnouncementModel announcement) async {
    try {
      final announcements = await getCachedAnnouncements();
      announcements.add(announcement);
      await cacheAnnouncements(announcements);
    } catch (e) {
      throw CacheException(message: 'Erro ao adicionar anúncio ao cache: $e');
    }
  }

  @override
  Future<void> updateCachedAnnouncement(AnnouncementModel announcement) async {
    try {
      final announcements = await getCachedAnnouncements();
      final index = announcements.indexWhere((a) => a.id == announcement.id);
      
      if (index == -1) {
        throw CacheException(message: 'Anúncio não encontrado no cache');
      }

      announcements[index] = announcement;
      await cacheAnnouncements(announcements);
    } catch (e) {
      throw CacheException(message: 'Erro ao atualizar anúncio no cache: $e');
    }
  }

  @override
  Future<void> removeCachedAnnouncement(String id) async {
    try {
      final announcements = await getCachedAnnouncements();
      announcements.removeWhere((a) => a.id == id);
      await cacheAnnouncements(announcements);
    } catch (e) {
      throw CacheException(message: 'Erro ao remover anúncio do cache: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(_cacheKey);
    } catch (e) {
      throw CacheException(message: 'Erro ao limpar cache: $e');
    }
  }
}
