import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart';

import '../../../../../data/models/app_user.dart';
import '../../../../../data/models/message.dart';
import '../../../../../utilitiies/extensions.dart';
import '../../../../../widgets/cached_image.dart';
import '../chat_body_viewmodel.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({
    required this.message,
    required this.sendByUser,
    required this.first,
    required this.last,
    required this.overOneHour,
    Key? key,
  }) : super(key: key);
  final ChatMessage message;
  final bool sendByUser;
  final bool first;
  final bool last;
  final bool overOneHour;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          if (overOneHour && last)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                format(
                  message.sendTime,
                  locale: Localizations.localeOf(context).languageCode,
                ),
                style: FluentTheme.of(context).typography.body,
              ),
            ),
          Builder(builder: (context) {
            if (sendByUser) {
              return GestureDetector(
                //todo: add delete
                onLongPress: () {},
                child: _SendByCurrentUser(
                  message: message,
                  first: first,
                  last: last,
                ),
              );
            }
            return _SendByAnotherUser(
              message: message,
              first: first,
              last: last,
            );
          }),
        ],
      );
}

class _SendByCurrentUser extends StatelessWidget {
  const _SendByCurrentUser({
    required this.message,
    required this.first,
    required this.last,
    Key? key,
  }) : super(key: key);
  final ChatMessage message;
  final bool first;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        right: 2,
        top: 2,
        bottom: first ? 10 : 2,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.accentColor.normal,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(15),
                      bottomLeft: const Radius.circular(15),
                      topRight: last ? const Radius.circular(15) : Radius.zero,
                      bottomRight:
                          first ? const Radius.circular(15) : Radius.zero,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      message.message,
                      style: theme.typography.body!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (first)
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 10),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    format(
                      message.sendTime,
                      locale: Localizations.localeOf(context).languageCode,
                    ),
                    style: theme.typography.caption,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class _SendByAnotherUser extends StatelessWidget {
  const _SendByAnotherUser({
    required this.message,
    required this.first,
    required this.last,
    Key? key,
  }) : super(key: key);
  final ChatMessage message;
  final bool first;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 2,
        top: 2,
        bottom: first ? 10 : 2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (last)
            Padding(
              padding: const EdgeInsets.only(bottom: 2, left: 50),
              child: Row(
                children: [
                  Text(
                    '',
                    style: theme.typography.body,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 2, right: 8),
                child: SizedBox(
                  width: 45,
                  height: 45,
                  child: FutureBuilder<AppUser>(
                    future: context.read<ChatPageVM>().getUserData(
                          message.userReference,
                          message.userId,
                        ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }
                      final data = snapshot.data;
                      if (data == null) {
                        return const SizedBox.shrink();
                      }
                      return first
                          ? data.picture != null
                              ? CustomCachedImage(
                                  url: data.picture!,
                                  shape: BoxShape.circle,
                                )
                              : DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.accentColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      data.username
                                          .parsePersonTwoCharactersName(),
                                    ),
                                  ),
                                )
                          : const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.accentColor.withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                      topLeft: last ? const Radius.circular(15) : Radius.zero,
                      bottomLeft:
                          first ? const Radius.circular(15) : Radius.zero,
                      topRight: const Radius.circular(15),
                      bottomRight: const Radius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      message.message,
                      maxLines: 100,
                      style: theme.typography.body,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          if (first)
            Padding(
              padding: const EdgeInsets.only(top: 2, left: 60),
              child: Row(
                children: [
                  Text(
                    format(
                      message.sendTime,
                      locale: Localizations.localeOf(context).languageCode,
                    ),
                    style: theme.typography.caption,
                  ),
                  const Spacer(),
                ],
              ),
            )
        ],
      ),
    );
  }
}
