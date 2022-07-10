import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/locator.dart';
import '../../../../app/router.dart';
import '../../../../data/models/site.dart';
import '../../../../data/repos/data_repo.dart';
import '../../../site/site_screen.dart';

class SitesPageVM extends ChangeNotifier {
  final _dataRepo = locator<DataRepo>();

  Future<void> goToSiteEditPage(BuildContext context, String siteId) async {
    await Navigator.of(context).pushNamed(
      Routes.site,
      arguments: SiteScreenArguments(siteId),
    );
  }

  bool loading = false;

  List<Site> get sites => _dataRepo.sites;

  Future<void> init() async {}
}
