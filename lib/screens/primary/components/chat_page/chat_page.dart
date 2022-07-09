import 'package:fluent_ui/fluent_ui.dart';

import '../../../../widgets/viewmodel_builder.dart';
import 'chat_body.dart';
import 'chat_body_viewmodel.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ViewModelBuilder<ChatPageVM>(
        viewModelBuilder: ChatPageVM.new,
        builder: (context) => const ChatBody(),
      );
}
