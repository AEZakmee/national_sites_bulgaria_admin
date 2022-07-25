import 'package:fluent_ui/fluent_ui.dart';

extension NameExtension on String {
  String parsePersonTwoCharactersName() {
    final spaceData = split(' ');
    if (spaceData.length >= 2) {
      return spaceData.take(2).map((e) => e[0].toUpperCase()).join();
    }

    final beforeNonLeadingCapitalLetter = RegExp('(?=(?!^)[A-Z])');
    final data = split(beforeNonLeadingCapitalLetter);

    if (data.length >= 2) {
      return data.take(2).map((e) => e[0].toUpperCase()).join();
    }

    return substring(0, 1).toUpperCase();
  }
}

extension ColorExtension on String {
  Color toColor() {
    final hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
