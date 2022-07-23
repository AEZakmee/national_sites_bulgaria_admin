import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../../providers/theme_provider.dart';
import '../../../../widgets/locale_switcher.dart';
import '../../widgets/arrow_button.dart';
import '../login_viewmodel.dart';
import 'input_fields.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<AuthVM>(
        builder: (context, prov, child) => Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Stack(
                  children: [
                    const ArrowButtonBackground(
                      hasShadow: true,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          elevation: 16,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
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
                  padding: EdgeInsets.only(top: 30),
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
