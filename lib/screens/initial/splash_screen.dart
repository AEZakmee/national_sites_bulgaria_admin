import 'package:fluent_ui/fluent_ui.dart';

import '../../app/locator.dart';
import '../../widgets/viewmodel_builder.dart';
import 'splash_viewmodel.dart';
import 'widgets/body.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ViewModelBuilder<InitialViewModel>(
        viewModelBuilder: locator<InitialViewModel>,
        builder: (context) => const InitialAnimation(),
      );
}
