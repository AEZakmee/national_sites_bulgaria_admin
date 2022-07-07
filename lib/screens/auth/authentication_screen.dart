import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

import 'authentication_viewmodel.dart';
import 'components/body.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => KeyboardDismissOnTap(
        child: Scaffold(
          body: ChangeNotifierProvider(
            create: (_) => AuthVM(),
            child: const Scaffold(
              body: Body(),
            ),
          ),
        ),
      );
}
