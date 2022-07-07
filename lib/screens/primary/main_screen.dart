import 'package:fluent_ui/fluent_ui.dart';

import '../../widgets/viewmodel_builder.dart';
import 'main_viewmodel.dart';
import 'widgets/body.dart';

class PrimaryScreen extends StatelessWidget {
  const PrimaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ViewModelBuilder<PrimaryViewModel>(
        viewModelBuilder: PrimaryViewModel.new,
        onModelReady: (viewModel) => viewModel.init(),
        builder: (context, viewModel) => const Body(),
      );
}
