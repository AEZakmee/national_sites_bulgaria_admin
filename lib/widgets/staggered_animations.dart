import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

int handleNumber(BuildContext context) {
  final size = MediaQuery.of(context).size.width;
  if (size < 1100) {
    return 3;
  }
  if (size < 1400) {
    return 4;
  }
  if (size < 1700) {
    return 5;
  }
  return 6;
}

class StaggeredListView extends StatelessWidget {
  final int count;
  final Function child;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool shrinkWrap;
  const StaggeredListView({
    required this.count,
    required this.child,
    Key? key,
    this.physics,
    this.controller,
    this.shrinkWrap = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => AnimationLimiter(
        child: ListView.builder(
          itemCount: count,
          physics: physics,
          shrinkWrap: shrinkWrap,
          controller: controller,
          itemBuilder: (BuildContext context, int index) =>
              AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: child(index),
              ),
            ),
          ),
        ),
      );
}

class SitesGridView extends StatelessWidget {
  final int count;
  final Function child;
  final bool shrinkWrap;
  final ScrollPhysics? scrollPhysics;
  const SitesGridView({
    required this.count,
    required this.child,
    Key? key,
    this.shrinkWrap = false,
    this.scrollPhysics,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => AnimationLimiter(
        child: GridView.count(
          crossAxisCount: handleNumber(context),
          shrinkWrap: shrinkWrap,
          physics: scrollPhysics,
          children: List.generate(
            count,
            (int index) => AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 500),
              columnCount: count ~/ 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: child(index),
                ),
              ),
            ),
          ),
        ),
      );
}

class StaggeredColumn extends StatelessWidget {
  final int count;
  final List<Widget> children;
  const StaggeredColumn({
    required this.count,
    required this.children,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: children,
          ),
        ),
      );
}

class StaggeredRow extends StatelessWidget {
  final int count;
  final List<Widget> children;
  const StaggeredRow({
    required this.count,
    required this.children,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => AnimationLimiter(
        child: Row(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => ScaleAnimation(
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: children,
          ),
        ),
      );
}
