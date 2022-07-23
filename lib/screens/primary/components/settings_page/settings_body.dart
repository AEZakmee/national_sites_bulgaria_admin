import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../providers/localization_provider.dart';
import '../../../../providers/theme_provider.dart';
import '../../../../widgets/vertical_separator.dart';
import '../../main_viewmodel.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.visualSettings),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ToggleSwitch(
                    checked: context.watch<ThemeProvider>().isDarkTheme,
                    onChanged: (_) =>
                        context.read<ThemeProvider>().switchTheme(),
                    content: Text(AppLocalizations.of(context)!.darkTheme),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: SizedBox(
                      width: double.infinity,
                      child: DropDownButton(
                        title: Text(AppLocalizations.of(context)!.language),
                        items: [
                          MenuFlyoutItem(
                            text: const Text('English'),
                            leading: context
                                        .watch<LocalizationProvider>()
                                        .getLocale()
                                        .languageCode ==
                                    'en'
                                ? const Icon(FluentIcons.check_mark)
                                : null,
                            onPressed: () => context
                                .read<LocalizationProvider>()
                                .setLanguage('en'),
                          ),
                          MenuFlyoutItem(
                            text: const Text('Български'),
                            leading: context
                                        .watch<LocalizationProvider>()
                                        .getLocale()
                                        .languageCode ==
                                    'ru'
                                ? const Icon(FluentIcons.check_mark)
                                : null,
                            onPressed: () => context
                                .read<LocalizationProvider>()
                                .setLanguage('ru'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      child: Text(AppLocalizations.of(context)!.logOut),
                      onPressed: () => context.read<PrimaryViewModel>().logout(
                            context,
                          ),
                    ),
                  )
                ],
              ),
            ),
            const FluentVerticalSeparator(),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      );
}
