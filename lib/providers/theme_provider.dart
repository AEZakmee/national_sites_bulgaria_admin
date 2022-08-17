import 'package:fluent_ui/fluent_ui.dart';

import '../services/theme_service.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeService themeService;

  ThemeProvider({required this.themeService});

  bool get isDarkTheme => themeService.brightness == Brightness.dark;

  Future<void> switchTheme() async {
    switch (themeService.brightness) {
      case Brightness.light:
        themeService.brightness = Brightness.dark;
        await themeService.setTheme(Brightness.dark);
        break;
      case Brightness.dark:
        themeService.brightness = Brightness.light;
        await themeService.setTheme(Brightness.light);
        break;
    }
    notifyListeners();
  }

  ThemeData lightTheme() => ThemeData(
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );

  ThemeData darkTheme() => ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        micaBackgroundColor: Colors.grey.withOpacity(0.6),
        scaffoldBackgroundColor: Colors.black.withOpacity(0.2),
        acrylicBackgroundColor: Colors.black.withOpacity(0.5),
        inactiveBackgroundColor: Colors.black.withOpacity(0.7),
        focusTheme: const FocusThemeData(
          glowFactor: 4.0,
        ),
      );

  ThemeMode get themeMode => isDarkTheme ? ThemeMode.dark : ThemeMode.light;
}
