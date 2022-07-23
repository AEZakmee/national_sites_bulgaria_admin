import 'package:fluent_ui/fluent_ui.dart';

import '../../../../widgets/viewmodel_builder.dart';
import 'settings_body.dart';
import 'settings_page_viewmodel.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ViewModelBuilder<SettingsPageVM>(
        viewModelBuilder: SettingsPageVM.new,
        builder: (context) => const SettingsBody(),
      );
}
