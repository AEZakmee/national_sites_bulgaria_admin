import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fluent_ui/fluent_ui.dart';

final colorTints = [
  '#2986cc',
  '#3e92d1',
  '#539ed6',
  '#69aadb',
  '#7eb6e0',
  '#94c2e5',
  '#a9ceea',
  '#bedaef',
  '#d4e6f4',
  '#e9f2f9',
];

final colorShades = [
  '#2986cc',
  '#2478b7',
  '#206ba3',
  '#1c5d8e',
  '#18507a',
  '#144366',
  '#103551',
  '#0c283d',
  '#081a28',
  '#040d14',
];

class LinearData {
  final int domainFn;
  final int measureFn;
  String? _label;
  String get label => _label ?? domainFn.toString();

  LinearData(
    this.domainFn,
    this.measureFn, [
    String? label,
  ]) {
    _label = label;
  }
}

//Most liked places
//Most disliked places

//Town with most sites
//Site with most images

//Most voted places
//Least voted places

//Most trending - most chat messages
//Least trending - least chat messages

final tempData = [
  LinearData(0, 100, 'Test'),
  LinearData(1, 75, 'Test 2'),
  LinearData(2, 25, 'Test 3'),
  LinearData(3, 52),
  LinearData(4, 15),
  LinearData(5, 25),
  LinearData(6, 35),
  LinearData(7, 45),
];

class StatisticsPageVM extends ChangeNotifier {
  List<charts.Series<LinearData, num>> pieData(
    String id, {
    bool darkTheme = false,
  }) =>
      _dataBuilder(id, darkTheme);

  List<charts.Series<LinearData, num>> _dataBuilder(
    String id,
    bool darkTheme,
  ) =>
      [
        charts.Series<LinearData, int>(
          id: id,
          data: tempData,
          domainFn: (LinearData data, _) => data.domainFn,
          measureFn: (LinearData data, _) => data.measureFn,
          labelAccessorFn: (LinearData data, _) => data.label,
          colorFn: (LinearData data, _) => _colorBuilder(data),
          insideLabelStyleAccessorFn: (LinearData data, _) =>
              _insideLabelBuilder(data),
          outsideLabelStyleAccessorFn: (LinearData data, _) => darkTheme
              ? _outsideLabelBuilderDark(data)
              : _outsideLabelBuilderLight(data),
        ),
      ];

  charts.Color _colorBuilder(LinearData data) => charts.Color.fromHex(
        code: colorTints[data.domainFn],
      );

  charts.TextStyleSpec _insideLabelBuilder(LinearData data) =>
      charts.TextStyleSpec(
        color: charts.Color.fromHex(
          code: colorShades.reversed.toList()[data.domainFn],
        ),
      );

  charts.TextStyleSpec _outsideLabelBuilderDark(LinearData data) =>
      charts.TextStyleSpec(
        color: charts.Color.fromHex(
          code: colorShades.first,
        ),
      );

  charts.TextStyleSpec _outsideLabelBuilderLight(LinearData data) =>
      charts.TextStyleSpec(
        color: charts.Color.fromHex(
          code: colorShades.last,
        ),
      );
}
