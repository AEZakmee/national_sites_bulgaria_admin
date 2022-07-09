import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import '../../../../widgets/cached_image.dart';

class SiteCard extends StatelessWidget {
  const SiteCard({
    required this.imageUrl,
    required this.imageHash,
    required this.title,
    Key? key,
    this.onTap,
  }) : super(key: key);
  final String imageUrl;
  final String imageHash;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return GestureDetector(
      child: Card(
        backgroundColor: theme.cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.typography.title,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: SizedBox.expand(
                      child: CustomCachedImage(
                        url: imageUrl,
                        hash: imageHash,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: FluentTheme.of(context).micaBackgroundColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            FontAwesome5.pencil_alt,
                            size: 20,
                            color: FluentTheme.of(context).activeColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
