import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:get_it/get_it.dart';

import '../data/repos/data_repo.dart';
import '../providers/localization_provider.dart';
import '../providers/theme_provider.dart';
import '../screens/initial/splash_viewmodel.dart';
import '../screens/primary/main_viewmodel.dart';
import '../screens/site/site_viewmodel.dart';
import '../services/firestore_service.dart';
import '../services/localization_service.dart';
import '../services/theme_service.dart';

final locator = GetIt.instance;

void setup() {
  locator
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<Firestore>(() => Firestore.instance)
    ..registerLazySingleton<ThemeService>(ThemeService.new)
    ..registerLazySingleton<LocalizationService>(LocalizationService.new)
    ..registerLazySingleton<FirestoreService>(
      () => FirestoreService(
        db: locator<Firestore>(),
        auth: locator<FirebaseAuth>(),
      ),
    )
    ..registerLazySingleton<DataRepo>(
      () => DataRepo(
        fireStoreService: locator<FirestoreService>(),
      ),
    )
    ..registerFactory<ThemeProvider>(
      () => ThemeProvider(
        themeService: locator<ThemeService>(),
      ),
    )
    ..registerFactory<LocalizationProvider>(
      () => LocalizationProvider(
        localizationService: locator<LocalizationService>(),
      ),
    )
    ..registerFactory<InitialViewModel>(
      () => InitialViewModel(
        auth: locator<FirebaseAuth>(),
        dataRepo: locator<DataRepo>(),
      ),
    )
    ..registerFactory<PrimaryViewModel>(
      () => PrimaryViewModel(
        auth: locator<FirebaseAuth>(),
        dataRepo: locator<DataRepo>(),
      ),
    )
    ..registerFactory<SiteScreenVM>(
      () => SiteScreenVM(
        firestore: locator<FirestoreService>(),
      ),
    );
}
