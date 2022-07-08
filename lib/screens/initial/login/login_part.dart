import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/content.dart';
import 'login_viewmodel.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SizedBox(
          width: 400,
          child: ChangeNotifierProvider(
            create: (_) => AuthVM(),
            child: const Scaffold(
              body: Body(),
            ),
          ),
        ),
      );
}
