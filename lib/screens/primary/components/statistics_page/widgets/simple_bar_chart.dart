import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fluent_ui/fluent_ui.dart';

import '../statistics_page_viewmodel.dart';

class CustomSimpleBarChart extends StatelessWidget {
  const CustomSimpleBarChart(
    this.seriesList, {
    Key? key,
    this.animate = false,
    this.label,
  }) : super(key: key);

  final List<charts.Series<BarData, String>> seriesList;
  final bool animate;
  final String? label;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                label!,
                style: FluentTheme.of(context).typography.bodyLarge,
              ),
            ),
          Expanded(
            child: charts.BarChart(
              seriesList,
              animate: animate,
            ),
          ),
        ],
      );
}
