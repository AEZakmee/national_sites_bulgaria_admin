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

  Future<void> goToSiteEditPage(BuildContext context, [String? siteId]) async {
    await Navigator.of(context).pushNamed(
      Routes.site,
      arguments: SiteScreenArguments(siteId),
    );
    await _dataRepo.updateSites();
  }

  Future<void> delete(String id) async {
    try {
      await _firestoreService.deleteSite(id);
      await _dataRepo.updateSites();
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  bool loading = false;

  List<Site> get sites => _dataRepo.sites;

  Future<void> init() async {
    _dataRepo.addListener(notifyListeners);
  }

  void onDispose() {
    _dataRepo.removeListener(notifyListeners);
  }
}
