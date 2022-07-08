import 'package:fluent_ui/fluent_ui.dart';
import 'package:national_sites_bulgaria_admin/widgets/viewmodel_builder.dart';

import 'sites_body.dart';
import 'sites_page_viewmodel.dart';

class SitesPage extends StatelessWidget {
  const SitesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ViewModelBuilder<SitesPageVM>(
        viewModelBuilder: SitesPageVM.new,
        builder: (context) => const ScaffoldPage(
          content: SitesBody(),
        ),
      );
}
