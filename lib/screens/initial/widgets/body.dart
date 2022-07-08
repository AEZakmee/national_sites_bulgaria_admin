import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../utilitiies/constants.dart';
import '../introduction/introduction.dart';
import '../login/login_part.dart';
import '../splash_viewmodel.dart';

class InitialAnimation extends StatefulWidget {
  const InitialAnimation({Key? key}) : super(key: key);

  @override
  State<InitialAnimation> createState() => _InitialAnimationState();
}

class _InitialAnimationState extends State<InitialAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    context.read<InitialViewModel>().checkUser(context);
    _animController = AnimationController(vsync: this);
    _animController.addListener(() {
      if (_animController.value > 0.2) {
        _animController.stop();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<InitialViewModel>();
    return Container(
      color: FluentTheme.of(context).micaBackgroundColor,
      child: Row(
        children: [
          Flexible(
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: kSplashScreenGradient(context),
                boxShadow: [kBoxShadow(context)],
                borderRadius: viewModel.userIsLogged
                    ? const BorderRadius.only(
                        bottomRight: Radius.circular(60),
                        topRight: Radius.circular(60),
                      )
                    : null,
              ),
              child: Lottie.asset(
                'assets/lottie/bulgaria_flag.json',
                controller: _animController,
                onLoaded: (composition) {
                  _animController
                    ..duration = composition.duration
                    ..forward();
                },
              ),
            ),
          ),
          AnimatedSwitcher(
            switchInCurve: Curves.easeOut,
            duration: Duration(milliseconds: viewModel.showLogin ? 750 : 1000),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                viewModel.showLogin
                    ? DrillInPageTransition(
                        animation: animation,
                        child: child,
                      )
                    : SizeTransition(
                        sizeFactor: animation,
                        axis: Axis.horizontal,
                        child: child,
                      ),
            child: viewModel.userIsLogged
                ? viewModel.showLogin
                    ? const LoginWidget()
                    : const IntroductionWidget()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
