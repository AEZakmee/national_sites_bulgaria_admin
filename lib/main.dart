import 'package:desktop_window/desktop_window.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/token_store.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:national_sites_bulgaria_admin/services/localization_service.dart';

import 'app/app.dart';
import 'app/locator.dart';
import 'app/providers.dart';
import 'services/theme_service.dart';

Future<void> initApp() async {
  await dotenv.load(fileName: '.env');

  await DesktopWindow.setMinWindowSize(const Size(800, 600));

  FirebaseAuth.initialize(dotenv.get('API_KEY'), VolatileStore());
  Firestore.initialize(dotenv.get('PROJECT_ID'));

  setup();
  await locator<LocalizationService>().init();
  await locator<ThemeService>().init();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();
  runApp(const ProviderInitializer(child: MyApp()));
}
