import 'package:fluent_ui/fluent_ui.dart';

import '../../widgets/viewmodel_builder.dart';
import 'splash_viewmodel.dart';
import 'widgets/body.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ViewModelBuilder<SplashViewModel>(
        viewModelBuilder: SplashViewModel.new,
        builder: (context) => const SplashScreenAnimation(),
      );
}
