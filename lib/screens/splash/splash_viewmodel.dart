import 'package:firedart/auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../app/router.dart';

class SplashViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool userIsLogged = false;

  Future checkUser(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
    if (_auth.isSignedIn) {
      //await _dataRepo.init();
      return Navigator.of(context).pushReplacementNamed(Routes.primary);
    } else {
      userIsLogged = true;
    }
    notifyListeners();
  }

  void goToAuthenticationScreen(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(Routes.auth);
  }
}
