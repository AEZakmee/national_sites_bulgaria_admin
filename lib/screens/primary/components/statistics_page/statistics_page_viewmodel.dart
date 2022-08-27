// ignore_for_file: cascade_invocations

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/locator.dart';
import '../../../../data/models/site.dart';
import '../../../../services/firestore_service.dart';

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

class Data {
  int number;
  final String title;

  Data({required this.number, required this.title});
}

class LinearData {
  final int domainFn;
  num measureFn;
  final String hexColor;
  String? _label;
  String get label => _label ?? domainFn.toString();

  LinearData(
    this.domainFn,
    this.measureFn,
    this.hexColor, [
    String? label,
  ]) {
    _label = label;
  }
}

class BarData {
  final String label;
  final num data;
  final String? name;

  BarData(this.label, this.data, [this.name]);
}

class StatisticsPageVM extends ChangeNotifier {
  final _firestoreService = locator<FirestoreService>();

  late List<BarData> mostVotedSites;
  late List<BarData> leastVotedSites;

  late List<LinearData> mostLikedSites;
  late List<LinearData> mostDislikedSites;
  late List<LinearData> mostSitesTown;
  late List<LinearData> mostPhotosSites;

  bool loading = true;
  bool error = false;
  Future<void> init() async {
    final response = await _firestoreService.fetchSites();
    if (!response.success) {
      error = true;
      loading = false;
      notifyListeners();
    }

    final allSites = response.data;

    final List<Site> votedSites =
        allSites.where((element) => element.rating.count > 0).toList(
              growable: false,
            );

    votedSites.sort((a, b) => a.rating.count > b.rating.count ? 0 : 1);

    mostVotedSites = List.generate(
      5,
      (index) => BarData(
        index.toString(),
        votedSites[index].rating.count,
        votedSites[index].info.name,
      ),
    );

    leastVotedSites = List.generate(
      5,
      (index) => BarData(
        index.toString(),
        votedSites.reversed.toList()[index].rating.count,
        votedSites.reversed.toList()[index].info.name,
      ),
    );

    List<Site> likedSites = allSites
        .where((element) => element.rating.count > 0)
        .toList(growable: false);

    likedSites.sort((a, b) {
      final aRating = a.rating.total / a.rating.count;
      final bRating = b.rating.total / b.rating.count;
      return aRating > bRating ? 0 : 1;
    });

    mostLikedSites = List.generate(
      10,
      (index) => LinearData(
        index,
        likedSites[index].rating.total / likedSites[index].rating.count,
        colorTints[index],
        likedSites[index].info.name,
      ),
    );

    likedSites = likedSites.reversed.toList();

    mostDislikedSites = List.generate(
      10,
      (index) => LinearData(
        index,
        likedSites[index].rating.total / likedSites[index].rating.count,
        colorTints[index],
        likedSites[index].info.name,
      ),
    );

    final List<Site> mostPhotosList = List.generate(
      allSites.length,
      (index) => allSites[index],
    );

    mostPhotosList.sort((a, b) => a.images.length > b.images.length ? 0 : 1);

    mostPhotosSites = List.generate(
      mostPhotosList.length.clamp(0, 10),
      (index) => LinearData(
        index,
        mostPhotosList[index].images.length,
        colorTints[index],
        mostPhotosList[index].info.name,
      ),
    );

    final List<Data> sitesTownData = [];
    for (final site in allSites) {
      final contains =
          sitesTownData.map((e) => e.title).contains(site.info.town);
      if (contains) {
        sitesTownData
            .firstWhere((element) => element.title == site.info.town)
            .number++;
      } else {
        sitesTownData.add(Data(number: 1, title: site.info.town));
      }
    }

    sitesTownData.sort((a, b) => a.number > b.number ? 0 : 1);

    mostSitesTown = List.generate(
      sitesTownData.length.clamp(0, 10),
      (index) => LinearData(
        index,
        sitesTownData[index].number,
        colorTints[index],
        sitesTownData[index].title,
      ),
    );

    loading = false;
    notifyListeners();
  }

  List<charts.Series<LinearData, num>> pieData(
    String id, {
    bool darkTheme = false,
    List<LinearData>? data,
  }) =>
      _dataBuilder(id, darkTheme, data);

  List<charts.Series<BarData, String>> barData(
    String id, {
    bool darkTheme = false,
    List<BarData>? data,
  }) =>
      _barDataBuilder(id, darkTheme, data);

  List<charts.Series<BarData, String>> _barDataBuilder(
    String id,
    bool darkTheme,
    List<BarData>? data,
  ) =>
      [
        charts.Series<BarData, String>(
          id: id,
          colorFn: (_, __) => charts.Color.fromHex(
            code: colorShades.toList()[2],
          ),
          domainFn: (BarData data, _) => data.label,
          measureFn: (BarData data, _) => data.data,
          data: data ?? [],
        )
      ];

  List<charts.Series<LinearData, num>> _dataBuilder(
    String id,
    bool darkTheme,
    List<LinearData>? data,
  ) =>
      [
        charts.Series<LinearData, int>(
          id: id,
          data: data ?? [],
          domainFn: (LinearData data, _) => data.domainFn,
          measureFn: (LinearData data, _) => data.measureFn,
          labelAccessorFn: (LinearData data, _) => '${data.measureFn}',
          colorFn: (LinearData data, _) => _colorBuilder(data),
          insideLabelStyleAccessorFn: (LinearData data, _) =>
              _insideLabelBuilder(data),
          outsideLabelStyleAccessorFn: (LinearData data, _) => darkTheme
              ? _outsideLabelBuilderDark()
              : _outsideLabelBuilderLight(),
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

  charts.TextStyleSpec _outsideLabelBuilderDark() => charts.TextStyleSpec(
        color: charts.Color.fromHex(
          code: colorShades.first,
        ),
      );

  charts.TextStyleSpec _outsideLabelBuilderLight() => charts.TextStyleSpec(
        color: charts.Color.fromHex(
          code: colorShades.last,
        ),
      );
}
