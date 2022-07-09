import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/loading_indicator.dart';
import '../../../../widgets/staggered_animations.dart';
import 'site_card.dart';
import 'sites_page_viewmodel.dart';

class SitesBody extends StatelessWidget {
  const SitesBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = context.watch<SitesPageVM>().sites;
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: context.watch<SitesPageVM>().loading
            ? const LoadingIndicator()
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
                  ),
                ),
              ),
      ),
    );
  }
}
