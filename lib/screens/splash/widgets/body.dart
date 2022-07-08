import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../utilitiies/constants.dart';
import '../../auth/components/arrow_button.dart';
import '../splash_viewmodel.dart';

class SplashScreenAnimation extends StatefulWidget {
  const SplashScreenAnimation({Key? key}) : super(key: key);

  @override
  State<SplashScreenAnimation> createState() => _SplashScreenAnimationState();
}

class _SplashScreenAnimationState extends State<SplashScreenAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    context.read<SplashViewModel>().checkUser(context);
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
    final showWelcomeScreen = context.watch<SplashViewModel>().userIsLogged;
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
                borderRadius: showWelcomeScreen
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
            duration: const Duration(seconds: 1),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              axisAlignment: 0,
              child: child,
            ),
            child: showWelcomeScreen
                ? const _RightPart()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _RightPart extends StatelessWidget {
  const _RightPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 30.0),
              Text(
                AppLocalizations.of(context)!.welcomeLabel,
                style: FluentTheme.of(context).typography.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30.0),
              Text(
                AppLocalizations.of(context)!.welcomeDescription,
                style: FluentTheme.of(context).typography.title,
              ),
              const SizedBox(height: 5.0),
              Text(
                AppLocalizations.of(context)!.welcomeSubDescription,
                style: FluentTheme.of(context).typography.caption,
              ),
              const SizedBox(height: 30.0),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 115,
                  width: 115,
                  decoration: BoxDecoration(
                    color: FluentTheme.of(context).micaBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: ArrowButton(
                      onPress: () => context
                          .read<SplashViewModel>()
                          .goToAuthenticationScreen(context),
                      isLoading: false,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      );
}
