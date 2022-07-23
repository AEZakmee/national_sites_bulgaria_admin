import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import 'donut_piechart.dart';
import 'statistics_page_viewmodel.dart';

class StatisticsBody extends StatelessWidget {
  const StatisticsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
        children: [
          SizedBox(
            height: 200,
            child: DonutAutoLabelChart(
              context.read<StatisticsPageVM>().pieData(
                    'someId',
                    darkTheme:
                        FluentTheme.of(context).brightness == Brightness.dark,
                  ),
              animate: true,
            ),
          ),
        ],
      );
}
