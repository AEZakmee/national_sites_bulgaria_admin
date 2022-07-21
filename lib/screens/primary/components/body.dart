import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:provider/provider.dart';

import '../main_viewmodel.dart';
import 'chat_page/chat_page.dart';
import 'sites_page/sites_page.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Consumer<PrimaryViewModel>(
      builder: (context, viewModel, _) {
        if (!viewModel.userIsAuthorized) {
          return const UnauthorizedWidget();
        }
        return NavigationView(
          content: NavigationBody(
            index: viewModel.index,
            children: [
              const ScaffoldPage(
                padding: EdgeInsets.zero,
                content: SitesPage(),
              ),
              const ScaffoldPage(
                padding: EdgeInsets.zero,
                content: ChatPage(),
              ),
              ScaffoldPage(
                content: Text(text.statistics),
              ),
              ScaffoldPage(
                content: Text(
                  text.settings,
                  style: FluentTheme.of(context).typography.title,
                ),
              ),
            ],
          ),
          pane: NavigationPane(
            selected: viewModel.index,
            onChanged: (i) => context.read<PrimaryViewModel>().updateIndex(i),
            displayMode: PaneDisplayMode.compact,
            footerItems: [
              PaneItem(
                icon: const Icon(FluentIcons.settings),
                title: Text(text.settings),
              ),
            ],
            items: [
              PaneItem(
                icon: const Icon(RpgAwesome.tower),
                title: Text(text.sites),
              ),
              PaneItem(
                icon: const Icon(MfgLabs.comment),
                title: Text(text.messages),
              ),
              PaneItem(
                icon: const Icon(MfgLabs.info_circled),
                title: Text(text.statistics),
              ),
            ],
          ),
        );
      },
    );
  }
}

class UnauthorizedWidget extends StatelessWidget {
  const UnauthorizedWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: FluentTheme.of(context).micaBackgroundColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.notAuthorizedLabel,
                style: FluentTheme.of(context).typography.title,
              ),
              Text(
                AppLocalizations.of(context)!.notAuthorizedDescription,
                style: FluentTheme.of(context).typography.body,
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () =>
                    context.read<PrimaryViewModel>().logout(context),
                child: Text(AppLocalizations.of(context)!.logOut),
              ),
            ],
          ),
        ),
      );
}
