import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart';

import '../../../../data/api_response.dart';
import '../../../../data/models/chat_room.dart';
import '../../../../widgets/cached_image.dart';
import '../../../../widgets/loading_indicator.dart';
import '../../../../widgets/staggered_animations.dart';
import 'chat_body_viewmodel.dart';

class RoomsList extends StatelessWidget {
  const RoomsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<ApiResponse<List<ChatRoom>>>(
        future: context.read<ChatPageVM>().rooms,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingIndicator();
          }
          final response = snapshot.data!;
          if (!response.success) {
            return const ErrorIndicator();
          }
          return StaggeredListView(
            count: response.data.length,
            child: (index) => RoomCard(
              room: response.data[index],
            ),
          );
        },
      );
}

class RoomCard extends StatelessWidget {
  const RoomCard({
    required this.room,
    Key? key,
  }) : super(key: key);
  final ChatRoom room;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return Consumer<ChatPageVM>(
      builder: (context, viewModel, _) => HoverButton(
        onTapDown: () => context.read<ChatPageVM>().loadRoom(
              room.siteId,
            ),
        builder: (BuildContext context, Set<ButtonStates> state) {
          final selectedRoomId = viewModel.selectedRoom?.siteId;
          Color? backgroundCardColor;

          if (state.contains(ButtonStates.hovering) ||
              (selectedRoomId != null && selectedRoomId == room.siteId)) {
            backgroundCardColor = theme.micaBackgroundColor;
          }

          return Column(
            children: [
              Container(
                color: backgroundCardColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: CustomCachedImage(
                          url: room.roomImage,
                          hash: room.imageHash,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              room.roomName,
                              overflow: TextOverflow.ellipsis,
                              style: FluentTheme.of(context).typography.body,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              room.lastMessage,
                              overflow: TextOverflow.ellipsis,
                              style: FluentTheme.of(context).typography.caption,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                Text(
                                  format(
                                    room.lastMessageTime,
                                    locale: Localizations.localeOf(context)
                                        .languageCode,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      FluentTheme.of(context).typography.body,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: theme.micaBackgroundColor,
              ),
            ],
          );
        },
      ),
    );
  }
}
