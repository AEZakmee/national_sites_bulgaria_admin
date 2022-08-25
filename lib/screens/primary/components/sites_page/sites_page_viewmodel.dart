import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/locator.dart';
import '../../../../app/router.dart';
import '../../../../data/models/site.dart';
import '../../../../data/repos/data_repo.dart';
import '../../../../services/firestore_service.dart';
import '../../../site/site_screen.dart';

class SitesPageVM extends ChangeNotifier {
  final _dataRepo = locator<DataRepo>();
  final _firestoreService = locator<FirestoreService>();

  List<Site> sites = [];

  Future<void> goToSiteEditPage(BuildContext context, [String? siteId]) async {
    await Navigator.of(context).pushNamed(
      Routes.site,
      arguments: SiteScreenArguments(siteId),
    );
    await updateSites();
  }

  Future<void> updateSites() async {
    final response = await _firestoreService.fetchSites();
    if (response.success) {
      sites = response.data;
    } else {
      error = true;
    }
    notifyListeners();
  }

  Future<void> delete(String id) async {
    await _firestoreService.deleteSite(id);
    await updateSites();
  }

  bool loading = true;
  bool error = false;

  Future<void> init() async {
    await updateSites();
    loading = false;
    notifyListeners();
  }
}
