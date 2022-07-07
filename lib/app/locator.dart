import 'package:get_it/get_it.dart';
import 'package:national_sites_bulgaria_admin/services/localization_service.dart';

import '../services/theme_service.dart';

final locator = GetIt.instance;

void setup() {
  locator
    ..registerLazySingleton(ThemeService.new)
    ..registerLazySingleton(LocalizationService.new);
}
