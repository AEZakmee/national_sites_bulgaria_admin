import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../../utilitiies/constants.dart';
import '../../../../widgets/staggered_animations.dart';
import 'sites_page_viewmodel.dart';

class SitesPage extends StatelessWidget {
  const SitesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<SitesPageVM>(
        create: (_) => SitesPageVM(),
        child: Builder(
          builder: (context) => ScaffoldPage(
            content: SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: StaggeredGridView(
                  count: 100,
                  child: (index) {
                    const String title = 'Muzei za pedali';
                    const String image =
                        'https://media-cldnry.s-nbcnews.com/image/upload/t_fit-1240w,f_auto,q_auto:best/rockcms/2021-05/210520-nyc-pride-jm-2024-742174.jpg';
                    const String town = 'Gr. Bansko';
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SquareCard(
                        imageUrl: image,
                        town: town,
                        title: title,
                        onTap: () => context
                            .read<SitesPageVM>()
                            .goToSiteEditPage(context),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
}

// enum CardType {
//   square,
//   squareBig,
//   rectangle,
// }
//
// class Combinations {
//   int x;
//   int y;
//   CardType type;
//
//   Combinations(this.x, this.y, this.type);
// }
//
// Combinations getCombinationFromIndex(int index) {
//   if (index % 7 == 0) {
//     return Combinations(1, 2, CardType.rectangle);
//   }
//   if (index % 17 == 0) {
//     return Combinations(2, 2, CardType.squareBig);
//   }
//   return Combinations(1, 1, CardType.square);
// }

// class SitesPage extends StatelessWidget {
//   const SitesPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) => ChangeNotifierProvider<SitesPageVM>(
//         create: (_) => SitesPageVM(),
//         child: ScaffoldPage(
//           content: SizedBox.expand(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: SingleChildScrollView(
//                 child: StaggeredGrid.count(
//                   crossAxisCount: 3,
//                   mainAxisSpacing: 8,
//                   crossAxisSpacing: 8,
//                   children: [
//                     ...List.generate(100, (index) {
//                       final size = getCombinationFromIndex(index);
//                       return StaggeredGridTile.count(
//                         crossAxisCellCount: size.y,
//                         mainAxisCellCount: size.x,
//                         child: Builder(
//                           builder: (context) {
//                             const String title = 'Muzei za pedali';
//                             const String image =
//                                 'https://cdn.pixabay.com/photo/2020/09/18/08/01/brown-throated-sunbird-5581173_960_720.jpg';
//                             const String description =
//                                 'Tova e muzei za pedali, tuka ima mnogo cvetni neshta i pedali, Tova e muzei za pedali, tuka ima mnogo cvetni neshta i pedali, Tova e muzei za pedali, tuka ima mnogo cvetni neshta i pedali, Tova e muzei za pedali, tuka ima mnogo cvetni neshta i pedali Tova e muzei za pedali, tuka ima mnogo cvetni neshta i pedali Tova e muzei za pedali, tuka ima mnogo cvetni neshta i pedali Tova e muzei za pedali, tuka ima mnogo cvetni neshta i pedali Tova e muzei za pedali, tuka ima mnogo cvetni neshta i pedali Tova e muzei za pedali, tuka ima mnogo cvetni neshta i pedali Tova e muzei za pedali, tuka ima mnogo cvetni neshta i pedali Tova e muzei za pedali, tuka ima mnogo cvetni neshta i pedali Tova e muzei za pedali, tuka ima mnogo cvetni neshta i pedali Tova e muzei za pedali, tuka ima mnogo cvetni neshta i pedali';
//                             switch (size.type) {
//                               case CardType.square:
//                                 return SquareCard(
//                                   imageUrl: image,
//                                   description: description,
//                                   title: title,
//                                   onTap: () => context
//                                       .read<SitesPageVM>()
//                                       .goToSiteEditPage(context),
//                                 );
//                               case CardType.squareBig:
//                                 return SquareCard(
//                                   imageUrl: image,
//                                   description: description,
//                                   descriptionLines: 14,
//                                   title: title,
//                                   onTap: () => context
//                                       .read<SitesPageVM>()
//                                       .goToSiteEditPage(context),
//                                 );
//                               case CardType.rectangle:
//                                 return RectangleCard(
//                                   imageUrl: image,
//                                   description: description,
//                                   title: title,
//                                   onTap: () => context
//                                       .read<SitesPageVM>()
//                                       .goToSiteEditPage(context),
//                                 );
//                             }
//                           },
//                         ),
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
// }
//
class SquareCard extends StatelessWidget {
  const SquareCard({
    required this.imageUrl,
    required this.title,
    required this.town,
    Key? key,
    this.onTap,
  }) : super(key: key);
  final String imageUrl;
  final String title;
  final String town;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        backgroundColor: theme.cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: kUnderImageGradient(
                        theme.cardColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      title,
                      style: theme.typography.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      town,
                      style: theme.typography.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Spacer(),
                  Flexible(
                    child: Icon(
                      FluentIcons.edit,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
//
// class RectangleCard extends StatelessWidget {
//   const RectangleCard({
//     required this.imageUrl,
//     required this.title,
//     required this.description,
//     Key? key,
//     this.descriptionLines,
//     this.onTap,
//   }) : super(key: key);
//   final String imageUrl;
//   final String title;
//   final String description;
//   final int? descriptionLines;
//   final VoidCallback? onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = CustomTheme.of(context);
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         backgroundColor: theme.appTheme.cardColor,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: double.infinity,
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8.0),
//                     child: AspectRatio(
//                       aspectRatio: 16 / 12,
//                       child: CachedNetworkImage(
//                         imageUrl: imageUrl,
//                         fit: BoxFit.fitHeight,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 0,
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       width: 100,
//                       decoration: BoxDecoration(
//                         gradient: kOnRightImageGradient(
//                           theme.appTheme.cardColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               width: 3,
//             ),
//             Expanded(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     child: Text(
//                       title,
//                       style: theme.appTheme.typography.title,
//                       maxLines: 2,
//                       textAlign: TextAlign.center,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Flexible(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 6),
//                       child: Text(
//                         description,
//                         style: theme.appTheme.typography.bodyLarge,
//                         maxLines: descriptionLines ?? 15,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
