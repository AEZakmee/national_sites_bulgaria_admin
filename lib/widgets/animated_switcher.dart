import 'package:fluent_ui/fluent_ui.dart';

class DrillInAnimatedSwitcher extends StatefulWidget {
  const DrillInAnimatedSwitcher({
    required this.child,
    Key? key,
  }) : super(key: key);
  final Widget child;

  @override
  State<DrillInAnimatedSwitcher> createState() =>
      _DrillInAnimatedSwitcherState();
}

class _DrillInAnimatedSwitcherState extends State<DrillInAnimatedSwitcher>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    )..forward();

    _animation = Tween<double>(
      end: 1,
      begin: 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) => DrillInPageTransition(
        animation: _animation,
        child: FadeTransition(
          opacity: _animation,
          child: widget.child,
        ),
      );
}
