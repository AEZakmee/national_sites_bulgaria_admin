import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

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
        title: Text('Delete ${site.info.name}'),
        content: Text('Are you sure you want to delete ${site.info.name}?'),
        actions: [
          Button(
            child: const Text('Delete'),
            onPressed: () {
              Navigator.pop(context);
              return onDelete();
            },
          ),
          Button(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<SitesPageVM>().sites;
    return context.watch<SitesPageVM>().loading
        ? const SizedBox(
            width: double.infinity,
            child: Center(
              child: LoadingIndicator(),
            ),
          )
        : SitesGridView(
            count: data.length,
            child: (index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: SiteCard(
                imageUrl: data[index].images.first.url,
                imageHash: data[index].images.first.hash,
                title: data[index].info.name,
                onTap: () => context.read<SitesPageVM>().goToSiteEditPage(
                      context,
                      data[index].uid,
                    ),
                onDeleteTap: () => showDeleteDialog(
                  context,
                  data[index],
                  () => context.read<SitesPageVM>().delete(data[index].uid),
                ),
              ),
            ),
          );
  }
}
