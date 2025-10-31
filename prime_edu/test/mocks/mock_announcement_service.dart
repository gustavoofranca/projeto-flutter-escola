import 'package:mocktail/mocktail.dart';
import 'package:prime_edu/models/announcement_model.dart';
import 'package:prime_edu/models/user_model.dart';
import 'package:prime_edu/services/announcement_service.dart';

class MockAnnouncementService extends Mock implements AnnouncementService {
  @override
  Future<List<AnnouncementModel>> getAnnouncements({required UserModel user}) async {
    return super.noSuchMethod(
      Invocation.method(#getAnnouncements, [], {#user: user}),
      returnValue: [],
    ) as Future<List<AnnouncementModel>>;
  }

  @override
  Future<List<AnnouncementModel>> getUrgentAnnouncements({required UserModel user}) async {
    return super.noSuchMethod(
      Invocation.method(#getUrgentAnnouncements, [], {#user: user}),
      returnValue: [],
    ) as Future<List<AnnouncementModel>>;
  }
}
