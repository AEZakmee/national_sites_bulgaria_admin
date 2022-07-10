import 'package:fluent_ui/fluent_ui.dart';

import '../../widgets/viewmodel_builder.dart';
import 'components/body.dart';
import 'site_viewmodel.dart';

class SiteScreenArguments {
  String? siteId;
  SiteScreenArguments(this.siteId);
}

class SiteScreen extends StatelessWidget {
  const SiteScreen({
    required this.args,
    Key? key,
  }) : super(key: key);
  final SiteScreenArguments? args;

  @override
  Widget build(BuildContext context) => ViewModelBuilder<SiteScreenVM>(
        viewModelBuilder: () => SiteScreenVM(args),
        onModelReady: (vm) => vm.init(),
        onDispose: (vm) => vm.onDispose(),
        builder: (context) => const SiteBody(),
      );
}
