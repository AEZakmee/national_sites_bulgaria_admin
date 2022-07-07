import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/router.dart';

class SitesPageVM extends ChangeNotifier {
  Future<void> goToSiteEditPage(BuildContext context) async {
    await Navigator.of(context).pushNamed(Routes.site);
  }
}
