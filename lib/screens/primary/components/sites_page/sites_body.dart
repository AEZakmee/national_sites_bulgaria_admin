import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/models/site.dart';
import '../../../../widgets/loading_indicator.dart';
import '../../../../widgets/staggered_animations.dart';
import 'site_card.dart';
import 'sites_page_viewmodel.dart';

class SitesBody extends StatelessWidget {
  const SitesBody({
    Key? key,
  }) : super(key: key);

  Future<void> showDeleteDialog(
    BuildContext context,
    Site site,
    VoidCallback onDelete,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: Text(site.info.name),
        content: Text(
            '${AppLocalizations.of(context)!.areYouSureDelete} ${site.info.name}?'),
        actions: [
          Button(
            child: Text(AppLocalizations.of(context)!.delete),
            onPressed: () {
              Navigator.pop(context);
              return onDelete();
            },
          ),
          Button(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<SitesPageVM>().sites;
    final viewModel = context.watch<SitesPageVM>();
    if (viewModel.loading) {
      return const SizedBox(
        width: double.infinity,
        child: Center(
          child: LoadingIndicator(),
        ),
      );
    }

    if (viewModel.error) {
      return const SizedBox(
        width: double.infinity,
        child: Center(
          child: ErrorIndicator(),
        ),
      );
    }

    return SitesGridView(
      count: data.length + 1,
      child: (index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: index == 0
            ? const CreateNewSiteContainer()
            : SiteCard(
                imageUrl: data[index - 1].images.first.url,
                imageHash: data[index - 1].images.first.hash,
                title: data[index - 1].info.name,
                onTap: () => context.read<SitesPageVM>().goToSiteEditPage(
                      context,
                      data[index - 1].uid,
                    ),
                onDeleteTap: () => showDeleteDialog(
                  context,
                  data[index - 1],
                  () => context.read<SitesPageVM>().delete(
                        data[index - 1].uid,
                      ),
                ),
              ),
      ),
    );
  }
}

class CreateNewSiteContainer extends StatelessWidget {
  const CreateNewSiteContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => HoverButton(
        onTapDown: () => context.read<SitesPageVM>().goToSiteEditPage(context),
        builder: (
          BuildContext context,
          Set<ButtonStates> state,
        ) {
          final theme = FluentTheme.of(context);
          final isFocused = state.contains(ButtonStates.hovering);
          Color backgroundColor = theme.micaBackgroundColor;
          if (isFocused) {
            backgroundColor = theme.activeColor.withOpacity(0.2);
          }
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  FluentIcons.add,
                  size: 45,
                ),
                const SizedBox(
                  height: 20,
                ),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.addNewSite,
                    maxLines: 2,
                    style: FluentTheme.of(context).typography.title,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      );
}
