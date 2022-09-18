import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/animated_switcher.dart';
import '../../../../widgets/stack_loading_indicator.dart';
import '../../../../widgets/vertical_separator.dart';
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
              const FluentVerticalSeparator(),
            if (context.watch<ChatPageVM>().selectedRoom != null)
              Expanded(
                child: DrillInAnimatedSwitcher(
                  key: context.watch<ChatPageVM>().animationKey,
                  child: StackedLoadingIndicator(
                    loading: context.watch<ChatPageVM>().deleteLoading,
                    child: const MessagesBody(),
                  ),
                ),
              ),
          ],
        ),
      );
}
