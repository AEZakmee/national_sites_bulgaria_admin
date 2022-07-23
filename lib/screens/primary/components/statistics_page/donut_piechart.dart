import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'statistics_page_viewmodel.dart';

class DonutAutoLabelChart extends StatelessWidget {
  const DonutAutoLabelChart(
    this.seriesList, {
    Key? key,
    this.animate = false,
  }) : super(key: key);

  final List<charts.Series<LinearData, num>> seriesList;
  final bool animate;

  @override
  Widget build(BuildContext context) => charts.PieChart<num>(
        seriesList,
        animate: animate,
        defaultRenderer: charts.ArcRendererConfig(
          arcWidth: 40,
          arcRendererDecorators: [
            charts.ArcLabelDecorator(),
          ],
        ),
      );
}
