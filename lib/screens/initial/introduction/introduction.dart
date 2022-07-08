import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../splash_viewmodel.dart';
import '../widgets/arrow_button.dart';

class IntroductionWidget extends StatelessWidget {
  const IntroductionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
            width: 400,
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
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    AppLocalizations.of(context)!.welcomeSubDescription,
                    style: FluentTheme.of(context).typography.caption,
                    textAlign: TextAlign.center,
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
                              .read<InitialViewModel>()
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
          ),
        ),
      );
}
