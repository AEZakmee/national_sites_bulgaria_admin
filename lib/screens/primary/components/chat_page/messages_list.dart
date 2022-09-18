import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/message.dart';
import 'chat_body_viewmodel.dart';
import 'widgets/message_box.dart';

class MessagesBody extends StatelessWidget {
  const MessagesBody({Key? key}) : super(key: key);

  Future<void> showDeleteDialog(
    BuildContext context,
    ChatMessage message,
    VoidCallback onDelete,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => ContentDialog(
        content: Text(
            '${AppLocalizations.of(context)!.areYouSureDelete} ${message.message}?'),
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

  bool firstFromThisUser(ChatMessage current, ChatMessage? previous) {
    if (previous == null) {
      return true;
    }
    return current.userId != previous.userId;
  }

  bool lastFromThisUser(ChatMessage current, ChatMessage? next) {
    if (next == null) {
      return true;
    }
    return current.userId != next.userId;
  }

  bool overOneHourThanPrevious(ChatMessage current, ChatMessage? previous) {
    if (previous == null) {
      return true;
    }
    return current.sendTime.difference(previous.sendTime).inHours > 1;
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ChatPageVM>().messages;
    return ListView.builder(
      itemCount: data.length,
      reverse: true,
      controller: ScrollController(),
      itemBuilder: (BuildContext context, int index) => SizedBox(
        width: 200,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onLongPress: () => showDeleteDialog(
            context,
            data[index],
            () => context.read<ChatPageVM>().deleteMessage(data[index].uid),
          ),
          child: MessageBox(
            message: data[index],
            sendByUser: context.read<ChatPageVM>().sendByUser(data[index]),
            first: firstFromThisUser(
              data[index],
              index > 0 ? data[index - 1] : null,
            ),
            last: lastFromThisUser(
              data[index],
              index < data.length - 1 ? data[index + 1] : null,
            ),
            overOneHour: overOneHourThanPrevious(
              data[index],
              index < data.length - 1 ? data[index + 1] : null,
            ),
          ),
        ),
      ),
    );
  }
}
