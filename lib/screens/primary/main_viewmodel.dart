import 'package:fluent_ui/fluent_ui.dart';

class PrimaryViewModel extends ChangeNotifier {
  PrimaryViewModel();

  void init() {}

  int index = 0;

  void updateIndex(int index) {
    this.index = index;
    notifyListeners();
  }
}
