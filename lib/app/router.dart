import 'package:fluent_ui/fluent_ui.dart';
import '../screens/initial/splash_screen.dart';
import '../screens/primary/main_screen.dart';
import '../screens/site/site_screen.dart';

class Routes {
  static const String initial = '/';
  static const String primary = '/primary';
  static const String site = '/site-edit';
}

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.initial:
        return FluentPageRoute(
          builder: (_) => const InitialScreen(),
        );
      case Routes.primary:
        return FluentPageRoute(
          builder: (_) => const PrimaryScreen(),
        );
      case Routes.site:
        final args = settings.arguments as SiteScreenArguments?;
        return FluentPageRoute(
          builder: (_) => SiteScreen(
            args: args,
          ),
        );
      default:
        throw const FormatException('Route not found! Check routes again!');
    }
  }
}
