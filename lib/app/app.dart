import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/localization_provider.dart';
import '../providers/theme_provider.dart';
import 'router.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localizations = context.watch<LocalizationProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    return FluentApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.lightTheme(),
      darkTheme: themeProvider.darkTheme(),
      themeMode: themeProvider.themeMode,
      initialRoute: Routes.initial,
      onGenerateRoute: AppRouter.generateRoute,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        DefaultFluentLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: localizations.getLocale(),
      supportedLocales: localizations.getSupportedLocales(),
    );
  }
}
