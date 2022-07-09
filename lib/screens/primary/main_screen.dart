import 'package:fluent_ui/fluent_ui.dart';

import '../../widgets/viewmodel_builder.dart';
import 'components/body.dart';
import 'main_viewmodel.dart';

class PrimaryScreen extends StatelessWidget {
  const PrimaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ViewModelBuilder<PrimaryViewModel>(
        viewModelBuilder: PrimaryViewModel.new,
        onModelReady: (viewModel) => viewModel.init(),
        onDispose: (viewModel) => viewModel.onDispose(),
        builder: (context) => const Body(),
      );
}
