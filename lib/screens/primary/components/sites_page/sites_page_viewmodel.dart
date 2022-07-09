import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/locator.dart';
import '../../../../app/router.dart';
import '../../../../data/models/site.dart';
import '../../../../services/firestore_service.dart';
import '../../../site/site_screen.dart';

class SitesPageVM extends ChangeNotifier {
  final _firestore = locator<FirestoreService>();

  Future<void> goToSiteEditPage(BuildContext context, String siteId) async {
    await Navigator.of(context).pushNamed(
      Routes.site,
      arguments: SiteScreenArguments(siteId),
    );
  }

  bool loading = true;

  List<Site> sites = [];

  Future<void> init() async {
    sites = await _firestore.fetchSites();
    loading = false;
    notifyListeners();
  }
}
