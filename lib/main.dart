import 'package:desktop_window/desktop_window.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timeago/timeago.dart';

import 'app/app.dart';
import 'app/locator.dart';
import 'app/providers.dart';
import 'services/localization_service.dart';
import 'services/theme_service.dart';
import 'utilitiies/bulgarian_messages.dart';
import 'utilitiies/token_sotrage.dart';

Future<void> initApp() async {
  await dotenv.load();

  await DesktopWindow.setMinWindowSize(const Size(800, 600));

  FirebaseAuth.initialize(dotenv.get('API_KEY'), await HiveStore.create());
  Firestore.initialize(dotenv.get('PROJECT_ID'));

  setup();
  setLocaleMessages('ru', BulgarianMessages());

  await locator<LocalizationService>().init();
  await locator<ThemeService>().init();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();
  runApp(const ProviderInitializer(child: MyApp()));
}
