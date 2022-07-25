import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import 'simple_bar_chart.dart';
import '../statistics_page_viewmodel.dart';

class TopRowComponent extends StatelessWidget {
  const TopRowComponent({
    required this.data,
    required this.label,
    Key? key,
  }) : super(key: key);

  final List<BarData> data;
  final String label;

  @override
  Widget build(BuildContext context) {
    final darkTheme = FluentTheme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CustomSimpleBarChart(
              context.read<StatisticsPageVM>().barData(
                    label,
                    darkTheme: darkTheme,
                    data: data,
                  ),
              animate: true,
              label: label,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(
                    data.length,
                    (index) => Text(
                      '$index. ${data[index].name}',
                      style: FluentTheme.of(context).typography.caption,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
