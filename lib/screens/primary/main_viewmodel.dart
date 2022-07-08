import 'package:firedart/auth/firebase_auth.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../app/locator.dart';
import '../../app/router.dart';
import '../../data/repos/data_repo.dart';

class PrimaryViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _dataRepo = locator<DataRepo>();

  void init() {
    _dataRepo
      ..initListeners()
      ..addListener(notifyListeners);
  }

  void onDispose() {
    _dataRepo
      ..cancelListeners()
      ..removeListener(notifyListeners);
  }

  bool get userIsAuthorized => _dataRepo.user.admin;

  void logout(BuildContext context) {
    _auth.signOut();
    Navigator.of(context).pushReplacementNamed(Routes.auth);
  }

  int index = 0;

  void updateIndex(int index) {
    this.index = index;
    notifyListeners();
  }
}
