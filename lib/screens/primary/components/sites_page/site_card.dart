import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluttericon/octicons_icons.dart';
import '../../../../widgets/cached_image.dart';

class SiteCard extends StatelessWidget {
  const SiteCard({
    required this.imageUrl,
    required this.imageHash,
    required this.title,
    Key? key,
    this.onTap,
    this.onDeleteTap,
  }) : super(key: key);
  final String imageUrl;
  final String imageHash;
  final String title;
  final VoidCallback? onTap;
  final VoidCallback? onDeleteTap;

  @override
  Widget build(BuildContext context) => HoverButton(
        onTapDown: onTap,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: SizedBox.expand(
                          child: CustomCachedImage(
                            url: imageUrl,
                            hash: imageHash,
                          ),
                        ),
                      ),
                      if (isFocused)
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: onDeleteTap,
                            child: Container(
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: FluentTheme.of(context)
                                    .inactiveBackgroundColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  FluentIcons.delete,
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
                const SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  style: theme.typography.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      );
}
