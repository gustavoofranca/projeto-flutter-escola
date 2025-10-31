import 'package:flutter_test/flutter_test.dart';
import 'package:prime_edu/models/announcement_model.dart';

void main() {
  group('AnnouncementModel', () {
    final testAnnouncement = AnnouncementModel(
      id: '1',
      title: 'Test Announcement',
      content: 'This is a test announcement',
      teacherId: 'teacher_001',
      teacherName: 'Prof. Test',
      classId: '3A_2024',
      className: '3º Ano A',
      priority: AnnouncementPriority.medium,
      type: AnnouncementType.geral,
      createdAt: DateTime(2025, 1, 1),
      isActive: true,
    );

    test('should create an announcement with correct properties', () {
      expect(testAnnouncement.id, '1');
      expect(testAnnouncement.title, 'Test Announcement');
      expect(testAnnouncement.content, 'This is a test announcement');
      expect(testAnnouncement.teacherId, 'teacher_001');
      expect(testAnnouncement.teacherName, 'Prof. Test');
      expect(testAnnouncement.classId, '3A_2024');
      expect(testAnnouncement.className, '3º Ano A');
      expect(testAnnouncement.priority, AnnouncementPriority.medium);
      expect(testAnnouncement.type, AnnouncementType.geral);
      expect(testAnnouncement.isActive, isTrue);
    });

    test('should create a copy with updated properties', () {
      final updated = testAnnouncement.copyWith(
        title: 'Updated Title',
        content: 'Updated content',
        isActive: false,
      );

      expect(updated.id, '1');
      expect(updated.title, 'Updated Title');
      expect(updated.content, 'Updated content');
      expect(updated.teacherId, 'teacher_001');
      expect(updated.isActive, isFalse);
    });

    test('should convert to and from JSON', () {
      final json = testAnnouncement.toMap();
      final fromJson = AnnouncementModel.fromMap(json);

      expect(fromJson.id, testAnnouncement.id);
      expect(fromJson.title, testAnnouncement.title);
      expect(fromJson.content, testAnnouncement.content);
      expect(fromJson.teacherId, testAnnouncement.teacherId);
      expect(fromJson.teacherName, testAnnouncement.teacherName);
      expect(fromJson.classId, testAnnouncement.classId);
      expect(fromJson.className, testAnnouncement.className);
      expect(fromJson.priority, testAnnouncement.priority);
      expect(fromJson.type, testAnnouncement.type);
      expect(fromJson.isActive, testAnnouncement.isActive);
    });

    test('should handle null values in fromMap', () {
      final json = testAnnouncement.toMap()..remove('classId');
      final fromJson = AnnouncementModel.fromMap(json);
      
      expect(fromJson.classId, isNull);
    });
  });
}
