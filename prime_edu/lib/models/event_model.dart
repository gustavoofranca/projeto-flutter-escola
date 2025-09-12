import 'dart:convert';
import 'package:flutter/material.dart';

enum EventType { exam, meeting, holiday, fieldTrip, presentation, other }

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date; // Only date part is relevant (Y-M-D)
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final EventType type;
  final String location;
  final bool isAllDay;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.location,
    required this.isAllDay,
  });

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    EventType? type,
    String? location,
    bool? isAllDay,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
      location: location ?? this.location,
      isAllDay: isAllDay ?? this.isAllDay,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': DateUtils.dateOnly(date).toIso8601String(),
      'startTime': _timeOfDayToString(startTime),
      'endTime': _timeOfDayToString(endTime),
      'type': type.name,
      'location': location,
      'isAllDay': isAllDay,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: (map['description'] ?? '') as String,
      date: DateTime.parse(map['date'] as String),
      startTime: _timeOfDayFromString(map['startTime'] as String),
      endTime: _timeOfDayFromString(map['endTime'] as String),
      type: EventType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => EventType.other,
      ),
      location: (map['location'] ?? '') as String,
      isAllDay: (map['isAllDay'] ?? false) as bool,
    );
  }

  String toJson() => json.encode(toMap());
  factory EventModel.fromJson(String source) => EventModel.fromMap(json.decode(source));

  static String _timeOfDayToString(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  static TimeOfDay _timeOfDayFromString(String s) {
    final parts = s.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
}
