import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prime_edu/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:prime_edu/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:prime_edu/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:prime_edu/features/auth/domain/repositories/auth_repository.dart';
import 'package:prime_edu/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:prime_edu/features/auth/domain/usecases/sign_up_with_email_and_password.dart';
import 'package:prime_edu/features/auth/presentation/providers/auth_view_model.dart';
import 'package:prime_edu/features/auth/presentation/providers/auth_view_model_v2.dart';
import 'package:prime_edu/features/announcements/data/datasources/announcement_local_data_source.dart';
import 'package:prime_edu/features/announcements/data/datasources/announcement_local_data_source_impl.dart';
import 'package:prime_edu/features/announcements/data/repositories/announcement_repository_impl.dart';
import 'package:prime_edu/features/announcements/domain/repositories/announcement_repository.dart';
import 'package:prime_edu/features/announcements/domain/usecases/create_announcement.dart';
import 'package:prime_edu/features/announcements/domain/usecases/delete_announcement.dart';
import 'package:prime_edu/features/announcements/domain/usecases/get_announcements.dart';
import 'package:prime_edu/features/announcements/domain/usecases/get_urgent_announcements.dart';
import 'package:prime_edu/features/announcements/domain/usecases/update_announcement.dart';
import 'package:prime_edu/features/announcements/presentation/providers/announcement_view_model.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // ViewModels
  sl.registerFactory(
    () => AuthViewModel(
      signInWithEmailAndPassword: sl(),
      signUpWithEmailAndPassword: sl(),
    ),
  );
  
  sl.registerFactory(
    () => AuthViewModelV2(
      signInUseCase: sl(),
      signUpUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInWithEmailAndPassword(sl()));
  sl.registerLazySingleton(() => SignUpWithEmailAndPassword(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  //! Features - Announcements
  // ViewModel
  sl.registerFactory(
    () => AnnouncementViewModel(
      getAnnouncementsUseCase: sl(),
      getUrgentAnnouncementsUseCase: sl(),
      createAnnouncementUseCase: sl(),
      updateAnnouncementUseCase: sl(),
      deleteAnnouncementUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAnnouncements(sl()));
  sl.registerLazySingleton(() => GetUrgentAnnouncements(sl()));
  sl.registerLazySingleton(() => CreateAnnouncement(sl()));
  sl.registerLazySingleton(() => UpdateAnnouncement(sl()));
  sl.registerLazySingleton(() => DeleteAnnouncement(sl()));

  // Repository
  sl.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AnnouncementLocalDataSource>(
    () => AnnouncementLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
