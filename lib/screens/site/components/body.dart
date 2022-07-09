import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../site_viewmodel.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: FluentTheme.of(context).micaBackgroundColor,
        child: ScaffoldPage(
          header: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: () => context.read<SiteScreenVM>().goBack(context),
                      child: const Icon(
                        FluentIcons.back,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          padding: EdgeInsets.zero,
          content: context.select<SiteScreenVM, bool>((prov) => prov.loading)
              ? const SizedBox.shrink()
              : Container(),
        ),
      );
}
