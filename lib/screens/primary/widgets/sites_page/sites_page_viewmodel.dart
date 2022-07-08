import 'package:fluent_ui/fluent_ui.dart';
import 'package:national_sites_bulgaria_admin/data/models/site.dart';
import 'package:national_sites_bulgaria_admin/services/firestore_service.dart';

import '../../../../app/locator.dart';
import '../../../../app/router.dart';

class SitesPageVM extends ChangeNotifier {
  final _firestore = locator<FirestoreService>();

  Future<void> goToSiteEditPage(BuildContext context, String siteId) async {
    await Navigator.of(context).pushNamed(Routes.site);
  }

  Stream<List<Site>> get sites => _firestore.sitesStream();
}
