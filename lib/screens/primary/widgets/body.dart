import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../main_viewmodel.dart';
import 'sites_page/sites_page.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PrimaryViewModel>();

    return NavigationView(
      content: NavigationBody(
        index: viewModel.index,
        children: [
          const SitesPage(),
          ScaffoldPage(
            content: Text('Kur2'),
          ),
          ScaffoldPage(
            content: Text('Kur3'),
          ),
          ScaffoldPage(
            content: Text(
              'Settings',
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
            title: const Text('Settings'),
          ),
        ],
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.site_scan),
            title: const Text('Sites'),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.user_clapper),
            title: const Text('Kur2'),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.chat),
            title: const Text('Kur3'),
          ),
        ],
      ),
    );
  }
}
