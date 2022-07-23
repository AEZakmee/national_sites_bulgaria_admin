import 'package:fluent_ui/fluent_ui.dart';

import '../../../../widgets/viewmodel_builder.dart';
import 'statistics_body.dart';
import 'statistics_page_viewmodel.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ViewModelBuilder<StatisticsPageVM>(
        viewModelBuilder: StatisticsPageVM.new,
        builder: (context) => const StatisticsBody(),
      );
}
