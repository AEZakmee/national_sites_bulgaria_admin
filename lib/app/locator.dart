import 'package:get_it/get_it.dart';

import '../data/repos/data_repo.dart';
import '../services/firestore_service.dart';
import '../services/localization_service.dart';
import '../services/theme_service.dart';

final locator = GetIt.instance;

void setup() {
  locator
    ..registerLazySingleton(ThemeService.new)
    ..registerLazySingleton(LocalizationService.new)
    ..registerLazySingleton(FirestoreService.new)
    ..registerLazySingleton(DataRepo.new);
}
