import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/animated_switcher.dart';
import 'chat_body_viewmodel.dart';
import 'messages_list.dart';
import 'rooms_list.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Expanded(
              child: RoomsList(),
            ),
            if (context.watch<ChatPageVM>().selectedRoom != null)
              Container(
                margin: const EdgeInsets.all(20),
                height: double.infinity,
                width: 1,
                color: FluentTheme.of(context).scaffoldBackgroundColor,
              ),
            if (context.watch<ChatPageVM>().selectedRoom != null)
              Expanded(
                child: DrillInAnimatedSwitcher(
                  key: context.watch<ChatPageVM>().animationKey,
                  child: const MessagesBody(),
                ),
              ),
          ],
        ),
      );
}
