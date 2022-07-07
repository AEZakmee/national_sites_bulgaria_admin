import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
import '../../../utilitiies/constants.dart';
import '../../../widgets/locale_switcher.dart';
import '../authentication_viewmodel.dart';
import 'arrow_button.dart';
import 'input_fields.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<AuthVM>(
        builder: (context, prov, child) => Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  gradient: kSplashScreenGradient(context),
                ),
              ),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width / 4,
              left: MediaQuery.of(context).size.width / 4,
              top: 150,
              child: Stack(
                children: [
                  const ArrowButtonBackground(
                    hasShadow: true,
                  ),
                  Column(
                    children: [
                      Card(
                        elevation: 16,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            children: [
                              const InputFields(),
                              if (prov.hasAuthError)
                                Center(
                                  child: Text(
                                    prov.authErrorString(context),
                                    style: FluentTheme.of(context)
                                        .typography
                                        .caption,
                                  ),
                                ),
                              const SizedBox(
                                height: 55,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 55,
                      ),
                    ],
                  ),
                  ArrowButtonBackground(
                    child: ArrowButton(
                      onPress: () => context.read<AuthVM>().signUp(context),
                      isLoading: context.watch<AuthVM>().isLoading,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    // ignore: prefer_const_constructors
                    LocaleSwitcher(
                      name: 'English',
                      // ignore: prefer_const_constructors
                      locale: Locale('en'),
                    ),
                    // ignore: prefer_const_constructors
                    LocaleSwitcher(
                      name: 'Български',
                      // ignore: prefer_const_constructors
                      locale: Locale('ru'),
                    )
                  ],
                ),
              ),
            ),
            const Align(
              alignment: Alignment.topRight,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(right: 15, top: 15),
                  child: CustomDayNightSwitcher(),
                ),
              ),
            ),
          ],
        ),
      );
}

class CustomDayNightSwitcher extends StatelessWidget {
  const CustomDayNightSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeSwitcher = context.watch<ThemeProvider>();
    return SizedBox(
      height: 70,
      width: 70,
      child: DayNightSwitcherIcon(
        isDarkModeEnabled: themeSwitcher.isDarkTheme,
        onStateChanged: (isDarkModeEnabled) {
          themeSwitcher.switchTheme();
        },
      ),
    );
  }
}
