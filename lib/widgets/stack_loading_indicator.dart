import 'package:fluent_ui/fluent_ui.dart';

class StackedLoadingIndicator extends StatelessWidget {
  final Widget child;
  final bool loading;

  const StackedLoadingIndicator({
    required this.child,
    required this.loading,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          SizedBox.expand(
            child: child,
          ),
          if (loading)
            AbsorbPointer(
              child: SizedBox.expand(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: FluentTheme.of(context).shadowColor.withOpacity(0.2),
                  ),
                  child: const Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: ProgressRing(),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
}
