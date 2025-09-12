import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';

class CalendarProvider extends ChangeNotifier {
  static const _storageKey = 'calendar_events';

  bool _isLoading = false;
  String? _error;
  final List<EventModel> _events = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<EventModel> get allEvents => List.unmodifiable(_events)..sort((a,b)=> a.date.compareTo(b.date));

  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _loadFromStorage();
    } catch (e) {
      _error = 'Erro ao carregar eventos: $e';
    } finally {
      _setLoading(false);
    }
  }

  List<EventModel> eventsForDate(DateTime date) {
    return _events.where((e) => _isSameDay(e.date, date)).toList()
      ..sort((a, b) => _compareByTime(a, b));
  }

  List<EventModel> upcomingEvents({int limit = 5}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final list = _events
        .where((e) => e.date.isAfter(today) || _isSameDay(e.date, today))
        .toList()
      ..sort((a, b) {
        final dc = a.date.compareTo(b.date);
        return dc != 0 ? dc : _compareByTime(a, b);
      });
    return limit > 0 ? list.take(limit).toList() : list;
  }

  Future<bool> addEvent(EventModel event) async {
    try {
      _events.add(event);
      await _saveToStorage();
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateEvent(EventModel event) async {
    final idx = _events.indexWhere((e) => e.id == event.id);
    if (idx == -1) return false;
    try {
      _events[idx] = event;
      await _saveToStorage();
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteEvent(String id) async {
    final idx = _events.indexWhere((e) => e.id == id);
    if (idx == -1) return false;
    try {
      _events.removeAt(idx);
      await _saveToStorage();
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  // Storage
  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null || jsonString.isEmpty) return;
    final List<dynamic> raw = json.decode(jsonString);
    _events
      ..clear()
      ..addAll(raw.map((m) => EventModel.fromMap(m as Map<String, dynamic>)));
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = _events.map((e) => e.toMap()).toList();
    await prefs.setString(_storageKey, json.encode(raw));
  }

  // Helpers
  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  int _compareByTime(EventModel a, EventModel b) {
    final at = a.startTime.hour * 60 + a.startTime.minute;
    final bt = b.startTime.hour * 60 + b.startTime.minute;
    return at.compareTo(bt);
  }
}
