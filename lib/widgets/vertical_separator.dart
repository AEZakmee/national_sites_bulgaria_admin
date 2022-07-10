import 'package:fluent_ui/fluent_ui.dart';

class FluentVerticalSeparator extends StatelessWidget {
  const FluentVerticalSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(20),
        height: double.infinity,
        width: 1,
        color: FluentTheme.of(context).micaBackgroundColor,
      );
}

class FluentHorizontalSeparator extends StatelessWidget {
  const FluentHorizontalSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(20),
        height: 1,
        width: double.infinity,
        color: FluentTheme.of(context).micaBackgroundColor,
      );
}
