import 'package:fluent_ui/fluent_ui.dart';

import '../app/locator.dart';
import '../services/theme_service.dart';

class ThemeProvider extends ChangeNotifier {
  final themeService = locator<ThemeService>();

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
      );

  ThemeMode get themeMode => isDarkTheme ? ThemeMode.dark : ThemeMode.light;
}
