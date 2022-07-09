import 'package:flutter/cupertino.dart';

import '../../app/locator.dart';
import '../../data/models/site.dart';
import '../../services/firestore_service.dart';
import 'site_screen.dart';

class SiteScreenVM extends ChangeNotifier {
  final _firestore = locator<FirestoreService>();

  final SiteScreenArguments? args;
  SiteScreenVM(this.args);

  late Site site;

  bool loading = true;

  Future<void> init() async {
    final id = args?.siteId;
    if (id != null) {
      await loadExistingSite(id);
    } else {
      loadEmptySide();
    }

    loading = false;
    notifyListeners();
  }

  Future<void> loadExistingSite(String id) async {
    site = await _firestore.fetchSite(id);
  }

  void loadEmptySide() {
    site = Site.empty();
  }

  void onDispose() {}

  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}
